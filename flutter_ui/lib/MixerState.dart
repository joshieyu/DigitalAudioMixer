import 'package:flutter/material.dart';
import 'package:flutter_ui/WebSocketService.dart';
import 'package:json_path/json_path.dart';
import 'package:json_schema/json_schema.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:json_patch/json_patch.dart';

Future<Map<String, dynamic>> loadMixerStateSchema() async {
  final schemaString =
      await rootBundle.loadString('assets/mixer_state_schema.json');
  return jsonDecode(schemaString);
}

class MixerState extends ChangeNotifier {
  Map<String, dynamic> _state;

  // JSON Schema for validation (define your schema here)
  final Map<String, dynamic> _jsonSchema = {
    "\$schema": "http://json-schema.org/draft-07/schema#",
    "type": "object",
    "properties": {
      "auto_mixer": {
        "type": "object",
        "properties": {
          "running": {"type": "boolean"}
        },
        "required": ["running"]
      },
      "channels": {
        "type": "array",
        "minItems": 9,
        "maxItems": 9,
        "items": {
          "type": "object",
          "properties": {
            "id": {"type": "integer"},
            "name": {"type": "string"},
            "input_gain": {"type": "number", "minimum": -48.0, "maximum": 24.0},
            "output_gain": {
              "type": "number",
              "minimum": -48.0,
              "maximum": 24.0
            },
            "panning": {"type": "number", "minimum": -1.0, "maximum": 1.0},
            "muted": {"type": "boolean"},
            "soloed": {"type": "boolean"},
            "effects": {
              "type": "object",
              "properties": {
                "compressor": {
                  "type": "object",
                  "properties": {
                    "enabled": {"type": "boolean"},
                    "comp_threshold": {
                      "type": "number",
                      "minimum": -60.0,
                      "maximum": 0.0
                    },
                    "comp_ratio": {
                      "type": "number",
                      "minimum": 1.0,
                      "maximum": 20.0
                    },
                    "comp_attack": {
                      "type": "number",
                      "minimum": 5.0,
                      "maximum": 100.0
                    },
                    "comp_release": {
                      "type": "number",
                      "minimum": 5.0,
                      "maximum": 100.0
                    },
                    "comp_makeup_gain": {
                      "type": "number",
                      "minimum": 0.0,
                      "maximum": 12.0
                    }
                  },
                  "required": [
                    "enabled",
                    "comp_threshold",
                    "comp_ratio",
                    "comp_attack",
                    "comp_release",
                    "comp_makeup_gain"
                  ]
                },
                "equalizer": {
                  "type": "object",
                  "properties": {
                    "enabled": {"type": "boolean"},
                    "low_shelf_gain": {
                      "type": "number",
                      "minimum": -20.0,
                      "maximum": 20.0
                    },
                    "low_shelf_cutoff": {
                      "type": "number",
                      "minimum": 20.0,
                      "maximum": 1000.0
                    },
                    "band0_gain": {
                      "type": "number",
                      "minimum": -20.0,
                      "maximum": 20.0
                    },
                    "band0_cutoff": {
                      "type": "number",
                      "minimum": 60.0,
                      "maximum": 1000.0
                    },
                    "band0_q": {
                      "type": "number",
                      "minimum": 0.1,
                      "maximum": 6.0
                    },
                    "band1_gain": {
                      "type": "number",
                      "minimum": -20.0,
                      "maximum": 20.0
                    },
                    "band1_cutoff": {
                      "type": "number",
                      "minimum": 1000.0,
                      "maximum": 7000.0
                    },
                    "band1_q": {
                      "type": "number",
                      "minimum": 0.1,
                      "maximum": 6.0
                    },
                    "high_shelf_gain": {
                      "type": "number",
                      "minimum": -20.0,
                      "maximum": 20.0
                    },
                    "high_shelf_cutoff": {
                      "type": "number",
                      "minimum": 4000.0,
                      "maximum": 21050.0
                    },
                    "high_shelf_q": {
                      "type": "number",
                      "minimum": 0.1,
                      "maximum": 6.0
                    }
                  },
                  "required": [
                    "enabled",
                    "low_shelf_gain",
                    "low_shelf_cutoff",
                    "band0_gain",
                    "band0_cutoff",
                    "band0_q",
                    "band1_gain",
                    "band1_cutoff",
                    "band1_q",
                    "high_shelf_gain",
                    "high_shelf_cutoff",
                    "high_shelf_q"
                  ]
                },
                "reverb": {
                  "type": "object",
                  "properties": {
                    "enabled": {"type": "boolean"},
                    "reverb_time": {
                      "type": "number",
                      "minimum": 0.1,
                      "maximum": 10.0
                    }
                  },
                  "required": ["enabled", "reverb_time"]
                }
              },
              "required": ["compressor", "equalizer", "reverb"]
            }
          },
          "required": [
            "id",
            "name",
            "input_gain",
            "output_gain",
            "panning",
            "muted",
            "soloed",
            "effects"
          ]
        }
      }
    },
    "required": ["auto_mixer", "channels"]
  };

  MixerState(this._state);

  Map<String, dynamic> get state => _state;

  void updateState(String path, dynamic value) {
    // Validate the change against JSON Schema
    if (!_validateChange(path, value)) {
      throw Exception("Invalid state update for $path");
    }

    // Generate JSON Patch
    final patch = _generatePatch(path, value);

    // Apply the patch
    _applyPatch(patch);

    // Notify listeners
    notifyListeners();

    // Send JSON patch
    _sendPatch(patch);
  }

  bool _validateChange(String path, dynamic value) {
    // TODO: seems very inefficent to continually recreate schema
    final schema = JsonSchema.create(_jsonSchema);
    final updatedState = {..._state};

    // Virtually apply the change
    _applyPatch(_generatePatch(path, value), updatedState);

    // Validate against schema
    return schema.validate(updatedState).isValid;
  }

  List<Map<String, dynamic>> _generatePatch(String path, dynamic value) {
    return [
      {"op": "replace", "path": path, "value": value}
    ];
  }

  void _applyPatch(List<Map<String, dynamic>> patch,
      [Map<String, dynamic>? json]) {
    final target = json ?? _state;
    try {
      for (var operation in patch) {
        // Extract the path and value from the operation
        final pathSegments = (operation['path'] as String)
            .split('/')
            .where((segment) => segment.isNotEmpty)
            .toList();
        final value = operation['value'];

        // Traverse the JSON object to find the target location
        dynamic current = target;
        for (int i = 0; i < pathSegments.length - 1; i++) {
          final segment = pathSegments[i];
          if (current is List) {
            current = current[int.parse(segment)];
          } else if (current is Map<String, dynamic>) {
            current = current[segment];
          } else {
            throw Exception("Invalid path segment: $segment");
          }
        }

        // Apply the patch operation to the final segment
        final lastSegment = pathSegments.last;
        if (current is List) {
          current[int.parse(lastSegment)] = value;
        } else if (current is Map<String, dynamic>) {
          current[lastSegment] = value;
        } else {
          throw Exception(
              "Cannot apply patch: invalid path or target structure.");
        }
      }

      // Print updated state for debugging
      print("Updated state: $target");
      notifyListeners(); // Notify listeners to rebuild UI
    } catch (e) {
      throw Exception("Failed to apply JSON Patch: $e");
    }
  }

  void _sendPatch(List<Map<String, dynamic>> patch) {
    print("Sending patch: $patch");
    // Implement WebSocket transmission here
    // Example: WebSocketService.send(patch);
    WebSocketService().send(patch);
  }
}

extension ChannelExtension on Map<String, dynamic> {
  Map<String, dynamic> getChannel(int index) => this["channels"][index];
}

extension EffectsExtension on Map<String, dynamic> {
  Map<String, dynamic> get effects => this["effects"];
}
