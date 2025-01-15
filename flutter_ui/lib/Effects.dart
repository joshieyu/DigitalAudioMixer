import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MixerState.dart';

class Effects extends StatelessWidget {
  final int channelIndex;
  final Map<String, dynamic> effectsState;

  Effects({required this.channelIndex, required this.effectsState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Effects"),
        Selector<MixerState, Map<String, dynamic>>(
          selector: (_, mixerState) =>
              mixerState.state["channels"][channelIndex]["effects"]["compressor"],
          builder: (_, compressorState, __) => CompressorEffect(
            channelIndex: channelIndex,
            compressorState: compressorState,
          ),
        ),
        Selector<MixerState, Map<String, dynamic>>(
          selector: (_, mixerState) =>
              mixerState.state["channels"][channelIndex]["effects"]["equalizer"],
          builder: (_, equalizerState, __) => EqualizerEffect(
            channelIndex: channelIndex,
            equalizerState: equalizerState,
          ),
        ),
      ],
    );
  }
}

class CompressorEffect extends StatelessWidget {
  final int channelIndex;
  final Map<String, dynamic> compressorState;

  CompressorEffect({required this.channelIndex, required this.compressorState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Compressor"),
        Selector<MixerState, bool>(
          selector: (_, mixerState) =>
              mixerState.state["channels"][channelIndex]["effects"]["compressor"]["enabled"],
          builder: (_, enabled, __) => Switch(
            value: enabled,
            onChanged: (value) {
              final path = r'/channels/' +
                  channelIndex.toString() +
                  r'/effects/compressor/enabled';
              Provider.of<MixerState>(context, listen: false)
                  .updateState(path, value);
            },
          ),
        ),
        Selector<MixerState, double>(
          selector: (_, mixerState) =>
              mixerState.state["channels"][channelIndex]["effects"]["compressor"]["comp_threshold"],
          builder: (_, compThreshold, __) => Slider(
            value: compThreshold,
            min: -60.0,
            max: 0.0,
            onChanged: (value) {
              final path = r'/channels/' +
                  channelIndex.toString() +
                  r'/effects/compressor/comp_threshold';
              Provider.of<MixerState>(context, listen: false)
                  .updateState(path, value);
            },
          ),
        ),
        // Add more controls for other compressor parameters here...
      ],
    );
  }
}

class EqualizerEffect extends StatelessWidget {
  final int channelIndex;
  final Map<String, dynamic> equalizerState;

  EqualizerEffect({required this.channelIndex, required this.equalizerState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Equalizer"),
        Selector<MixerState, double>(
          selector: (_, mixerState) =>
              mixerState.state["channels"][channelIndex]["effects"]["equalizer"]["low_shelf_gain"],
          builder: (_, lowShelfGain, __) => Slider(
            value: lowShelfGain,
            min: -20.0,
            max: 20.0,
            onChanged: (value) {
              final path = r'/channels/' +
                  channelIndex.toString() +
                  r'/effects/equalizer/low_shelf_gain';
              Provider.of<MixerState>(context, listen: false)
                  .updateState(path, value);
            },
          ),
        ),
        // Add more controls for other EQ parameters here...
      ],
    );
  }
}
