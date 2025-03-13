import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MixerState.dart';
import 'Effects.dart';

class ChannelStrip extends StatelessWidget {
  final int channelIndex;
  final Map<String, dynamic> channelState;

  ChannelStrip({required this.channelIndex, required this.channelState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Channel ${channelIndex + 1}"),
        Selector<MixerState, double>(
          selector: (_, mixerState) =>
              mixerState.state["channels"][channelIndex]["input_gain"],
          builder: (_, inputGain, __) => RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: inputGain,
              min: -48.0,
              max: 24.0,
              onChanged: (value) {
                final path =
                    r'/channels/' + channelIndex.toString() + r'/input_gain';
                Provider.of<MixerState>(context, listen: false)
                    .updateState(path, value);
              },
            ),
          ),
        ),
        Selector<MixerState, bool>(
          selector: (_, mixerState) =>
              mixerState.state["channels"][channelIndex]["muted"],
          builder: (_, muted, __) => Switch(
            value: muted,
            onChanged: (value) {
              final path = r'/channels/' + channelIndex.toString() + r'/muted';
              Provider.of<MixerState>(context, listen: false)
                  .updateState(path, value);
            },
          ),
        ),
        Expanded(
          child: Selector<MixerState, Map<String, dynamic>>(
            selector: (_, mixerState) =>
                mixerState.state["channels"][channelIndex]["effects"],
            builder: (_, effectsState, __) => Effects(
              channelIndex: channelIndex,
              effectsState: effectsState,
            ),
          ),
        ),
      ],
    );
  }
}
