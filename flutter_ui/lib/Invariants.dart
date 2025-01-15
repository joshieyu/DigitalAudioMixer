class MixerConstants {
  static const double sampleRate = 44100.0;
}

class Range {
  final double min;
  final double max;
  const Range({required this.min, required this.max});
}

class EqualizerRanges {
  static const Range dB = Range(min: -20.0, max: 20.0);
  static const Range Q = Range(min: 0.1, max: 6.0);
  static const Range lowShelfCutoff = Range(min: 20.0, max: 1000.0);
  static const Range band0Cutoff = Range(min: 60.0, max: 1000.0);
  static const Range band1Cutoff = Range(min: 1000.0, max: 7000.0);
  static const Range highShelfCutoff =
      Range(min: 4000.0, max: MixerConstants.sampleRate / 2 - 1000);
}

class CompressorRanges {
  static const Range threshold = Range(min: -60.0, max: 0.0);
  static const Range ratio = Range(min: 1.0, max: 20.0);
  static const Range attack = Range(min: 5.0, max: 100.0);
  static const Range release = Range(min: 5.0, max: 100.0);
  static const Range makeupGain = Range(min: 0.0, max: 12.0);
}

class ReverbRanges {
  static const Range reverbTime = Range(min: 0.1, max: 10.0);
}

class ChannelStripRanges {
  static const Range gain = Range(min: -48.0, max: 24.0);
  static const Range pan = Range(min: -1.0, max: 1.0);
}