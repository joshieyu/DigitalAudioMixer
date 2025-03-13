import 'dart:convert';
import 'dart:io';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  WebSocket? _socket;

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal();

  Future<void> connect(String url) async {
    try {
      _socket = await WebSocket.connect(url);
      _socket!.listen(
        (data) {
          print('Received data: $data');
        },
        onDone: () {
          print('Connection closed');
        },
        onError: (error) {
          print('Error: $error');
        },
      );
      print('Connected to $url');
    } catch (e) {
      print('Failed to connect: $e');
    }
  }

  void send(List<Map<String, dynamic>> patch) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      _socket!.add(jsonEncode(patch));
      print('Sent patch: $patch');
    } else {
      print('WebSocket is not connected');
    }
  }

  void disconnect() {
    _socket?.close();
  }
}