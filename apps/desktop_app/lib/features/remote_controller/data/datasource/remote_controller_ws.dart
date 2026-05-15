import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:open_scripture/features/remote_controller/domain/entities/client_info.dart';
import 'package:shared/rc_protocol/rc_protocol.dart';

typedef OnMessage = void Function(RemoteCommand command, ClientId? clientId);

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
    _onMessage = onMessage;

    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);

    _listen();
  }

  void _removeClient(WebSocket socket) {
    final clientId =
        _clientsSockets.entries.firstWhereOrNull((e) => e.value == socket)?.key;
    if (clientId == null) return;
    _clientsSockets.remove(clientId);
    _clientsInfos.remove(clientId);
    _emit();
  }

  void _listen() async {
    await for (HttpRequest request in _server!) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        if (_clientsSockets.values.length >= maxClients) {
          request.response
            ..statusCode = HttpStatus.serviceUnavailable
            ..write('Max connections reached')
            ..close();
          continue;
        }

        final socket = await WebSocketTransformer.upgrade(request);
        String? clientId;

        socket.listen(
          (data) {
            final msg = jsonDecode(data as String) as Map<String, dynamic>;
            if (msg['type'] == RemoteCommandType.handshake.name) {
              clientId = msg['client_id'] as String;
              final deviceName =
                  msg['device_name'] as String? ?? 'Unknown device';
              _clientsSockets[clientId]?.close();
              _clientsSockets[clientId!] = socket;
              _clientsInfos[clientId!] = ClientInfo(
                id: clientId!,
                ipAdress: request.connectionInfo!.remoteAddress.address,
                deviceName: deviceName,
              );
              _emit();
              return;
            }

            try {
              final command = RemoteCommand.fromRaw(data);
              _onMessage?.call(command, clientId);
            } catch (e) {
              print('Invalid message: $e');
            }
          },
          onDone: () {
            _removeClient(socket);
            _emit();
          },
          onError: (_) {
            _removeClient(socket);
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
