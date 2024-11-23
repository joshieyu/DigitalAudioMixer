import 'package:flutter/material.dart';
import 'package:flutter_ui/ChannelStrip.dart';

class Mixer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Audio Mixer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MixerHomePage(),
    );
  }
}

class MixerHomePage extends StatefulWidget {
  @override
  _MixerHomePageState createState() => _MixerHomePageState();
}

class _MixerHomePageState extends State<MixerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Audio Mixer'),
      ),
        body: Center(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(9, (index) => ChannelStrip(id: index)),
          ),
        ),
    );
  }
}