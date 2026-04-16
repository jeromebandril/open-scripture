import 'dart:convert';
import 'dart:io';

import 'package:shared/models/remote_command.dart';

typedef OnMessage = void Function(RemoteCommand command, WebSocket client);

class RemoteControllerWSServer {
  HttpServer? _server;
  final List<WebSocket> _clients = [];

  OnMessage? _onMessage;

  Future<void> start({
    required int port,
    required OnMessage onMessage,
  }) async {
    _onMessage ??= onMessage;

    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);

    _listen();
  }

  void _listen() async {
    await for (HttpRequest request in _server!) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        final socket = await WebSocketTransformer.upgrade(request);

        _clients.add(socket);

        socket.listen(
          (data) {
            try {
              final decoded = jsonDecode(data);
              final command = RemoteCommand.fromJson(decoded);
              _onMessage?.call(command, socket);
            } catch (e) {
              print('Invalid message: $e');
            }
          },
          onDone: () => _clients.remove(socket),
          onError: (_) => _clients.remove(socket),
        );
      } else {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..close();
      }
    }
  }

  void sendToAll(Map<String, dynamic> message) {
    final encoded = jsonEncode(message);
    for (final client in _clients) {
      client.add(encoded);
    }
  }

  void sendToClient(WebSocket client, Map<String, dynamic> message) {
    client.add(jsonEncode(message));
  }

  Future<void> stop() async {
    for (final c in _clients) {
      await c.close();
    }
    await _server?.close();
  }
}
