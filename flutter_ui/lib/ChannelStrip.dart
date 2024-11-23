import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ui/MixerState.dart';

class ChannelStrip extends StatefulWidget {
  final int id;

  ChannelStrip({required this.id});

  @override
  _ChannelStripState createState() => _ChannelStripState();
}

class _ChannelStripState extends State<ChannelStrip> {
  @override
  Widget build(BuildContext context) {
    final mixerState = Provider.of<MixerState>(context);
    final channelStrip = mixerState.channelStrips[widget.id];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.id.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        RotatedBox(
          quarterTurns: -1,
          child: Slider(
            value: channelStrip.gain,
            min: ChannelStripRanges.gain.min,
            max: ChannelStripRanges.gain.max,
            onChanged: (value) {
              setState(() {
                channelStrip.gain = value;
                mixerState.updateChannelStrip(widget.id, channelStrip);
              });
            },
          ),
        ),
        Text('Gain: ${(channelStrip.gain).toStringAsFixed(1)} dB'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                channelStrip.muted ? Icons.volume_off : Icons.volume_up,
              ),
              onPressed: () {
                setState(() {
                  channelStrip.muted = !channelStrip.muted;
                  mixerState.updateChannelStrip(widget.id, channelStrip);
                });
              },
            ),
            IconButton(
              icon: Icon(
                channelStrip.solo ? Icons.headset : Icons.headset_off,
              ),
              onPressed: () {
                setState(() {
                  channelStrip.solo = !channelStrip.solo;
                  mixerState.updateChannelStrip(widget.id, channelStrip);
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}