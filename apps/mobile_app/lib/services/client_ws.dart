import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_scripture_rc/services/device_identity_service.dart';
import 'package:shared/rc_protocol/rc_protocol.dart';
import 'package:uuid/uuid.dart';

const int connectTimeoutSeconds = 5;
const int pingFrequencySeconds = 10;
const int inactivityTimeoutSeconds = 1800;

class ConnectionStatus {
  final bool connected;
  final String? message;

  const ConnectionStatus(this.connected, {this.message});
}

class RemoteWsClient {
  final Map<String, Completer<Map<String, dynamic>>> _pendingRequests = {};

  late final AppLifecycleListener _lifecycleListener;

  RemoteWsClient({DeviceIdentity? deviceIdentity})
    : _deviceIdentity = deviceIdentity {
    _lifecycleListener = AppLifecycleListener(
      onPause: _onAppPause,
      onResume: _onAppResume,
    );
  }
  void _onAppPause() {
    _manuallyClosed = true;
    _inactivityTimer?.cancel();
    _socket?.close();
    _socket = null;
  }

  void _onAppResume() {
    if (_host == null || _port == null) return;
    _manuallyClosed = false;
    connect(_host!, _port!, retry: true);
  }

  final DeviceIdentity? _deviceIdentity;
  WebSocket? _socket;

  String? _host;
  int? _port;

  bool _manuallyClosed = false;

  DateTime? _lastActivityAt;
  Timer? _inactivityTimer;

  final StreamController<ConnectionStatus> _connectionController =
      StreamController<ConnectionStatus>.broadcast();

  Stream<ConnectionStatus> get connectionStream =>
      _connectionController.stream.distinct();

  Future<void> connect(String host, int port, {bool retry = false}) async {
    _host = host;
    _port = port;
    _manuallyClosed = false;

    try {
      if (_socket != null) {
        _socket!.close();
        _socket = null;
      }

      final socket = await WebSocket.connect(
        'ws://$host:$port',
      ).timeout(const Duration(seconds: connectTimeoutSeconds));

      socket.pingInterval = const Duration(seconds: pingFrequencySeconds);

      _socket = socket;
      _sendHandshake();
      _lastActivityAt = DateTime.now();

      _connectionController.add(
        ConnectionStatus(true, message: 'Connected to $host:$port'),
      );

      _listen(socket);
      _startInactivityTimer();

      _reconnectAttempt = 0;
    } catch (w) {
      _connectionController.add(
        ConnectionStatus(false, message: 'Failed to connect to $host:$port'),
      );
      if (retry) _scheduleReconnect();
    }
  }

  Future<void> disconnect() async {
    _manuallyClosed = true;

    _inactivityTimer?.cancel();

    await _socket?.close();
    _socket = null;

    _connectionController.add(ConnectionStatus(false));
  }

  void sendCommand(RemoteCommand command) {
    _socket?.add(
      jsonEncode({...command.toJson(), 'client_id': _deviceIdentity?.id}),
    );
  }

  Future<Map<String, dynamic>?> sendRequest(RemoteCommand command) {
    final requestId = const Uuid().v4();
    final completer = Completer<Map<String, dynamic>>();
    _pendingRequests[requestId] = completer;

    _socket?.add(
      jsonEncode({
        ...command.toJson(),
        'client_id': _deviceIdentity?.id,
        'request_id': requestId,
      }),
    );

    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        _pendingRequests.remove(requestId);
        return {};
      },
    );
  }

  Future<void> reconnect() async {
    if (_host == null || _port == null) return;
    await connect(_host!, _port!);
  }

  void _listen(WebSocket socket) {
    socket.listen(
      (data) {
        _lastActivityAt = DateTime.now();

        try {
          final msg = jsonDecode(data as String) as Map<String, dynamic>;
          final requestId = msg['request_id'] as String?;
          if (requestId != null && _pendingRequests.containsKey(requestId)) {
            _pendingRequests.remove(requestId)?.complete(msg);
          }
        } catch (_) {}
      },
      onDone: _handleDisconnect,
      onError: (_) => _handleDisconnect(),
      cancelOnError: true,
    );
  }

  void _sendHandshake() {
    _socket?.add(
      jsonEncode({
        'type': RemoteCommandType.handshake.name,
        'client_id': _deviceIdentity?.id,
        'device_name': _deviceIdentity?.name,
      }),
    );
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();

    _inactivityTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final last = _lastActivityAt;
      if (last == null) return;

      if (DateTime.now().difference(last).inSeconds >
          inactivityTimeoutSeconds) {
        disconnect();
      }
    });
  }

  void _handleDisconnect() {
    if (_socket == null) return;

    final socket = _socket!;
    _socket = null;

    _inactivityTimer?.cancel();

    socket.close();

    if (socket.closeCode == 4003 || socket.closeCode == 1000) {
      _connectionController.add(
        ConnectionStatus(false, message: socket.closeReason),
      );
      return;
    }

    if (!_manuallyClosed) {
      _scheduleReconnect();
      _connectionController.add(
        ConnectionStatus(
          false,
          message: 'Connection lost. Attempting to reconnect...',
        ),
      );
      return;
    }
  }

  int _reconnectAttempt = 0;
  bool _reconnecting = false;

  void _scheduleReconnect() {
    if (_reconnecting || _host == null || _port == null) return;

    _reconnecting = true;

    final delay = Duration(seconds: (2 * _reconnectAttempt).clamp(2, 30));

    _reconnectAttempt++;

    Future.delayed(delay, () async {
      _reconnecting = false;
      if (_manuallyClosed) return;
      await connect(_host!, _port!, retry: true);
    });
  }

  void dispose() {
    _lifecycleListener.dispose();
    _inactivityTimer?.cancel();
    _connectionController.close();
    _socket?.close();
  }
}
