import 'package:flutter/material.dart';
import 'package:flutter_ui/ChannelStrip.dart';
import 'package:flutter_ui/MixerState.dart';
import 'package:provider/provider.dart';


class Mixer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: List.generate(9, (index) {
          return Expanded(
            child: Selector<MixerState, Map<String, dynamic>>(
              selector: (_, mixerState) => mixerState.state["channels"][index],
              builder: (_, channelState, __) => ChannelStrip(
                channelIndex: index,
                channelState: channelState,
              ),
            ),
          );
        }),
      ),
    );
  }
}
