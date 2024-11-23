import 'package:flutter/material.dart';
import 'WebSocketService.dart';

class MixerState with ChangeNotifier {
  final WebSocketService _webSocketService = WebSocketService('ws://localhost:8080');
  List<ChannelStripModel> channelStrips =
      List.generate(9, (index) => ChannelStripModel());

  void updateChannelStrip(int index, ChannelStripModel channelStrip) {
    if (index >= 0 && index < channelStrips.length) {
      channelStrips[index] = channelStrip;
      notifyListeners();
    }
  }


void sendUpdate(String parameter, dynamic value) {
    final message = {
      'type': 'updateParameter',
      'parameter': parameter,
      'value': value,
    };
    _webSocketService.sendMessage(message);
  }

void setProperty<T>(String propertyName, T value, T Function() getter, void Function(T) setter) {
    setter(value);
    notifyListeners();
    sendUpdate(propertyName, value);
  }
}

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

class EqualizerModel with ChangeNotifier {
  double _lowShelfGain = 0.0;
  double _lowShelfCutoff = 20.0;
  double _band0Gain = 0.0;
  double _band0Cutoff = 60.0;
  double _band0Q = 0.1;
  double _band1Gain = 0.0;
  double _band1Cutoff = 1000.0;
  double _band1Q = 0.1;
  double _highShelfGain = 0.0;
  double _highShelfCutoff = 4000.0;
  double _highShelfQ = 0.1;

  double get lowShelfGain => _lowShelfGain;
  // set lowShelfGain(double value) {
  //   _lowShelfGain = value;
  //   notifyListeners();
  //   MixerState().sendUpdate('lowShelfGain', value);
  // }
  set lowShelfGain(double value) {
    MixerState().setProperty('lowShelfGain', value, () => _lowShelfGain, (val) => _lowShelfGain = val);
  }

  double get lowShelfCutoff => _lowShelfCutoff;
  set lowShelfCutoff(double value) {
    _lowShelfCutoff = value;
    notifyListeners();
  }

  double get band0Gain => _band0Gain;
  set band0Gain(double value) {
    _band0Gain = value;
    notifyListeners();
  }

  double get band0Cutoff => _band0Cutoff;
  set band0Cutoff(double value) {
    _band0Cutoff = value;
    notifyListeners();
  }

  double get band0Q => _band0Q;
  set band0Q(double value) {
    _band0Q = value;
    notifyListeners();
  }

  double get band1Gain => _band1Gain;
  set band1Gain(double value) {
    _band1Gain = value;
    notifyListeners();
  }

  double get band1Cutoff => _band1Cutoff;
  set band1Cutoff(double value) {
    _band1Cutoff = value;
    notifyListeners();
  }

  double get band1Q => _band1Q;
  set band1Q(double value) {
    _band1Q = value;
    notifyListeners();
  }

  double get highShelfGain => _highShelfGain;
  set highShelfGain(double value) {
    _highShelfGain = value;
    notifyListeners();
  }

  double get highShelfCutoff => _highShelfCutoff;
  set highShelfCutoff(double value) {
    _highShelfCutoff = value;
    notifyListeners();
  }

  double get highShelfQ => _highShelfQ;
  set highShelfQ(double value) {
    _highShelfQ = value;
    notifyListeners();
  }
}

class CompressorRanges {
  static const Range threshold = Range(min: -60.0, max: 0.0);
  static const Range ratio = Range(min: 1.0, max: 20.0);
  static const Range attack = Range(min: 5.0, max: 100.0);
  static const Range release = Range(min: 5.0, max: 100.0);
  static const Range makeupGain = Range(min: 0.0, max: 12.0);
}

class CompressorModel with ChangeNotifier {
  double _threshold = -20.0;
  double _ratio = 4.0;
  double _attack = 20.0;
  double _release = 100.0;
  double _makeupGain = 0.0;

  double get threshold => _threshold;
  set threshold(double value) {
    _threshold = value;
    notifyListeners();
  }

  double get ratio => _ratio;
  set ratio(double value) {
    _ratio = value;
    notifyListeners();
  }

  double get attack => _attack;
  set attack(double value) {
    _attack = value;
    notifyListeners();
  }

  double get release => _release;
  set release(double value) {
    _release = value;
    notifyListeners();
  }

  double get makeupGain => _makeupGain;
  set makeupGain(double value) {
    _makeupGain = value;
    notifyListeners();
  }
}

class ReverbRanges {
  static const Range reverbTime = Range(min: 0.1, max: 10.0);
}

class ReverbModel extends ChangeNotifier {
  double _reverbTime = 1.0;

  double get reverbTime => _reverbTime;
  set reverbTime(double value) {
    _reverbTime = value;
    notifyListeners();
  }
}

class ChannelStripRanges {
  static const Range gain = Range(min: -48.0, max: 24.0);
  static const Range pan = Range(min: -1.0, max: 1.0);
}

class ChannelStripModel with ChangeNotifier {
  double gain = 0.0;
  double pan = 0.0;
  bool muted = false;
  bool solo = false;

  final EqualizerModel equalizer;
  final CompressorModel compressor;
  final ReverbModel reverb;

  ChannelStripModel()
      : equalizer = EqualizerModel(),
        compressor = CompressorModel(),
        reverb = ReverbModel();
}
