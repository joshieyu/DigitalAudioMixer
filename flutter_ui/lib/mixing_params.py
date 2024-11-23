import torch
from dasp_pytorch import ParametricEQ, Compressor, NoiseShapedReverb, Gain

def restore_from_0to1(param, min_val, max_val):
    """Restore normalized parameter to its original range."""
    return param * (max_val - min_val) + min_val

class Mixer(torch.nn.Module):
    def __init__(
        self,
        sample_rate: float,
        min_gain_dB: int = -48.0,
        max_gain_dB: int = 24.0,
    ) -> None:
        super().__init__()
        self.num_params = 18  # Updated for EQ, Compressor, Gain, Pan, Reverb
        self.sample_rate = sample_rate
        self.min_gain_dB = min_gain_dB
        self.max_gain_dB = max_gain_dB

        # dasp-pytorch effect modules
        self.equalizer = ParametricEQ(sample_rate)
        self.compressor = Compressor(sample_rate)
        self.reverb = NoiseShapedReverb(sample_rate)
        self.gain = Gain(sample_rate)

    def forward(self, x: torch.Tensor, p: torch.Tensor):
        """Generate a mix of stems given mixing parameters normalized to (0,1).

        Args:
            x (torch.Tensor): Batch of waveform stem tensors with shape (bs, num_tracks, seq_len).
            p (torch.Tensor): Batch of normalized mixing parameters (0,1) for each stem with shape (bs, num_tracks, num_params)

        Returns:
            y (torch.Tensor): Batch of stereo waveform mixes with shape (bs, 2, seq_len)
        """
        bs, num_tracks, seq_len = x.size()

        # ------------- apply gain -------------
        gain_dB = p[..., 0]  # get gain parameter
        gain_dB = restore_from_0to1(gain_dB, self.min_gain_dB, self.max_gain_dB)
        gain_lin = 10 ** (gain_dB / 20.0)  # convert gain from dB scale to linear
        gain_lin = gain_lin.view(bs, num_tracks, 1)  # reshape for multiplication
        x = x * gain_lin  # apply gain (bs, num_tracks, seq_len)

        # ------------- apply EQ -------------
        # Using ParametricEQ for five bands: Low shelf, Band0, Band1, High shelf
        low_shelf_gain = restore_from_0to1(p[..., 2], -20.0, 20.0)  # low_shelf_gain_db
        low_shelf_cutoff = restore_from_0to1(p[..., 3], 20.0, 1000.0)  # low_shelf_cutoff_freq
        band0_gain = restore_from_0to1(p[..., 4], -20.0, 20.0)  # band0_gain_db
        band0_cutoff = restore_from_0to1(p[..., 5], 60.0, 1000.0)  # band0_cutoff_freq
        band0_q = restore_from_0to1(p[..., 6], 0.1, 6.0)  # band0_q_factor
        band1_gain = restore_from_0to1(p[..., 7], -20.0, 20.0)  # band1_gain_db
        band1_cutoff = restore_from_0to1(p[..., 8], 1000.0, 7000.0)  # band1_cutoff_freq
        band1_q = restore_from_0to1(p[..., 9], 0.1, 6.0)  # band1_q_factor
        high_shelf_gain = restore_from_0to1(p[..., 10], -20.0, 20.0)  # high_shelf_gain_db
        high_shelf_cutoff = restore_from_0to1(p[..., 11], 4000.0, (self.sample_rate // 2) - 1000)  # high_shelf_cutoff_freq
        high_shelf_q = restore_from_0to1(p[..., 12], 0.1, 6.0)  # high_shelf_q_factor

        eq_params = torch.stack([
            low_shelf_gain, low_shelf_cutoff, band0_gain, band0_cutoff, band0_q,
            band1_gain, band1_cutoff, band1_q, high_shelf_gain, high_shelf_cutoff, high_shelf_q
        ], dim=-1)
        eq_params = eq_params.view(bs * num_tracks, -1)  # reshape for EQ processing
        x = self.equalizer.process_normalized(x.view(bs * num_tracks, 2, -1), eq_params)  # apply EQ
        x = x.view(bs, num_tracks, 2, -1)  # reshape back

        # ------------- apply Compression -------------
        comp_threshold = restore_from_0to1(p[..., 13], -60.0, 0.0)  # Threshold in dB
        comp_ratio = restore_from_0to1(p[..., 14], 1.0, 20.0)  # Ratio
        comp_attack = restore_from_0to1(p[..., 15], 5.0, 100.0)  # Attack in ms
        comp_release = restore_from_0to1(p[..., 16], 5.0, 100.0)  # Release in ms
        comp_makeup_gain = restore_from_0to1(p[..., 17], 0.0, 12.0)  # Makeup gain in dB

        comp_params = torch.stack([comp_threshold, comp_ratio, comp_attack, comp_release, comp_makeup_gain], dim=-1)
        comp_params = comp_params.view(bs * num_tracks, -1)  # reshape for Compressor processing
        x = self.compressor.process_normalized(x.view(bs * num_tracks, 2, -1), comp_params)  # apply compression
        x = x.view(bs, num_tracks, 2, -1)  # reshape back

        # ------------- apply Reverb -------------
        reverb_time = restore_from_0to1(p[..., 18], 0.1, 10.0)  # Reverb time in seconds
        reverb_params = reverb_time.view(bs * num_tracks, 1)  # reshape for Reverb processing
        x = self.reverb.process_normalized(x.view(bs * num_tracks, 2, -1), reverb_params)  # apply reverb
        x = x.view(bs, num_tracks, 2, -1)  # reshape back

        # ------------- apply panning (last) -------------
        # expand mono stems to stereo, then apply panning
        pan = p[..., 1]  # get pan parameter
        pan_theta = pan * torch.pi / 2
        left_gain = torch.cos(pan_theta)
        right_gain = torch.sin(pan_theta)
        pan_gains_lin = torch.stack([left_gain, right_gain], dim=-1)
        pan_gains_lin = pan_gains_lin.view(bs, num_tracks, 2, 1)  # reshape for multiply
        x = x * pan_gains_lin  # (bs, num_tracks, 2, seq_len)

        # ----------------- apply mix -------------
        # generate a mix for each batch item by summing stereo tracks
        y = torch.sum(x, dim=1)  # (bs, 2, seq_len)

        p = torch.cat(
            (
                gain_dB.view(bs, num_tracks, 1),
                pan.view(bs, num_tracks, 1),
                eq_params.view(bs, num_tracks, -1),
                comp_params.view(bs, num_tracks, -1),
                reverb_params.view(bs, num_tracks, 1),
            ),
            dim=-1,
        )

        return y, p

# Create the mixer instance
sample_rate = 44100
mixer = Mixer(sample_rate)
print(mixer)
