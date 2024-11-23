import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel channel;

  WebSocketService(String url)
      : channel = WebSocketChannel.connect(Uri.parse(url));

  void sendMessage(Map<String, dynamic> message) {
    channel.sink.add(jsonEncode(message));
  }

  Stream<Map<String, dynamic>> get messages =>
      channel.stream.map((event) => jsonDecode(event));
  
  void close() {
    channel.sink.close();
  }
}
