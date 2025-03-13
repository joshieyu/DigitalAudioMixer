import 'package:flutter/material.dart';
import 'package:flutter_ui/WebSocketService.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ui/Mixer.dart';
import 'package:flutter_ui/MixerState.dart';

final Map<String, dynamic> initialState = {
  "auto_mixer": {"running": false},
  "channels": List.generate(9, (index) {
    return {
      "id": index,
      "name": "Channel $index",
      "input_gain": -24.0,
      "output_gain": -24.0,
      "panning": 0.0,
      "muted": false,
      "soloed": false,
      "effects": {
        "compressor": {
          "enabled": false,
          "comp_threshold": 0.0,
          "comp_ratio": 1.0,
          "comp_attack": 5.0,
          "comp_release": 5.0,
          "comp_makeup_gain": 0.0
        },
        "equalizer": {
          "enabled": false,
          "low_shelf_gain": 0.0,
          "low_shelf_cutoff": 20.0,
          "band0_gain": 0.0,
          "band0_cutoff": 60.0,
          "band0_q": 0.1,
          "band1_gain": 0.0,
          "band1_cutoff": 1000.0,
          "band1_q": 0.1,
          "high_shelf_gain": 0.0,
          "high_shelf_cutoff": 4000.0,
          "high_shelf_q": 0.1
        },
        "reverb": {"enabled": false, "reverb_time": 0.1}
      }
    };
  })
};

Future<void> main() async {
  final WebSocketService webSocketService = WebSocketService();
  await webSocketService.connect('ws://raspberrypi.local:9001');
  runApp(
    ChangeNotifierProvider(
      create: (context) => MixerState(initialState),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Mixer(),
    );
  }
}