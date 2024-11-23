import 'package:flutter/material.dart';

abstract class Effect extends StatelessWidget {
  final String name;

  Effect({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          buildEffectControls(context),
        ],
      ),
    );
  }

  Widget buildEffectControls(BuildContext context);
}

class EQEffect extends Effect {
  EQEffect() : super(name: 'Equalizer');

  @override
  Widget buildEffectControls(BuildContext context) {
    return Column(
      children: [
        // Add EQ specific controls here
        Text('EQ Controls'),
      ],
    );
  }
}

class CompressorEffect extends Effect {
  CompressorEffect() : super(name: 'Compressor');

  @override
  Widget buildEffectControls(BuildContext context) {
    return Column(
      children: [
        // Add Compressor specific controls here
        Text('Compressor Controls'),
      ],
    );
  }
}

class ReverbEffect extends Effect {
  ReverbEffect() : super(name: 'Reverb');

  @override
  Widget buildEffectControls(BuildContext context) {
    return Column(
      children: [
        // Add Reverb specific controls here
        Text('Reverb Controls'),
      ],
    );
  }
}