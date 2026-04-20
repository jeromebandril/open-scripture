import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:open_scripture/features/remote_controller/domain/entities/client_info.dart';
import 'package:shared/rc_protocol/rc_protocol.dart';

typedef OnMessage = void Function(RemoteCommand command, WebSocket client);

class RemoteControllerWSServer {
  static const int maxClients = 3;

  HttpServer? _server;
  final Map<ClientId, WebSocket> _clientsSockets = {};
  final Map<ClientId, ClientInfo> _clientsInfos = {};
  final _clientsController = StreamController<List<ClientInfo>>.broadcast();

  OnMessage? _onMessage;

  Stream<List<ClientInfo>> get clientsStream => _clientsController.stream;

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

        if (_clientsSockets.values.length >= maxClients) {
          request.response
            ..statusCode = HttpStatus.serviceUnavailable
            ..write('Max connections reached')
            ..close();
          continue;
        }

        final clientId = DateTime.now().microsecondsSinceEpoch.toString();
        _clientsSockets[clientId] = socket;
        _clientsInfos[clientId] = ClientInfo(
          id: clientId,
          ipAdress: request.connectionInfo!.remoteAddress.address,
        );
        _emit();

        socket.listen(
          (data) {
            try {
              print(data);
              final command = RemoteCommand.fromRaw(data);
              _onMessage?.call(command, socket);
            } catch (e) {
              print('Invalid message: $e');
            }
          },
          onDone: () {
            final entry =
                _clientsSockets.entries.firstWhere((e) => e.value == socket);

            final clientId = entry.key;

            _clientsSockets.remove(clientId);
            _clientsInfos.remove(clientId);

            _emit();
          },
          onError: (_) {
            final entry =
                _clientsSockets.entries.firstWhere((e) => e.value == socket);

            final clientId = entry.key;

            _clientsSockets.remove(clientId);
            _clientsInfos.remove(clientId);

            _emit();
          },
        );
      } else {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..close();
      }
    }
  }

  Future<void> disconnectClient(ClientId clientId) async {
    final socket = _clientsSockets[clientId];
    if (socket == null) return;

    socket.close(4003, 'You have been disconnected by the server');

    _clientsSockets.remove(clientId);
    _clientsInfos.remove(clientId);

    _emit();
  }

  void sendToAll(Map<String, dynamic> message) {
    for (final socket in _clientsSockets.values) {
      socket.add(jsonEncode(message));
    }
  }

  void sendToClient(ClientId clientId, Map<String, dynamic> message) {
    final socket = _clientsSockets[clientId];
    if (socket == null) return;

    socket.add(jsonEncode(message));
  }

  Future<void> stop() async {
    for (final c in _clientsSockets.values) {
      await c.close(1000, 'Server closed');
    }

    _clientsSockets.clear();
    _clientsInfos.clear();
    _emit();

    await _server?.close();
  }

  void _emit() => _clientsController.add(_clientsInfos.values.toList());
}
