import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared/models/remote_command_type.dart';

const int inactivityTimeoutSeconds = 3000;
const int connectTimeoutSeconds = 15;

class RemoteWsClient {
  WebSocket? _socket;

  String? _host;
  int? _port;

  bool _manuallyClosed = false;

  bool _connected = false;
  bool get isConnected => _connected;

  DateTime? _lastSeen;

  Timer? _heartbeatTimer;
  Timer? _watchdogTimer;

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream.distinct();

  Future<int> connect(String host, int port) async {
    _host = host;
    _port = port;

    try {
      _socket = await WebSocket.connect(
        'ws://$host:$port',
      ).timeout(const Duration(seconds: connectTimeoutSeconds));

      await Future.delayed(Duration());

      _connected = true;
      _lastSeen = DateTime.now();
      _connectionController.add(true);

      _listen();
      _startHeartbeat();
      _startWatchdog();
      return 0;
    } on TimeoutException {
      print('Connection timed out');
      _connected = false;
      return 1;
    } catch (e) {
      _connected = false;
      _connectionController.add(false);
      _scheduleReconnect();
      return 1;
    }
  }

  void _listen() {
    _socket?.listen(
      (data) {
        _lastSeen = DateTime.now();

        try {
          final msg = jsonDecode(data);

          // Handle pong
          if (msg["type"] == "pong") {
            return;
          }

          // Handle other messages if needed
        } catch (_) {
          // ignore invalid JSON
        }
      },
      onDone: () {
        _handleDisconnect();
      },
      onError: (_) {
        _handleDisconnect();
      },
      cancelOnError: true,
    );
  }

  void sendCommand(Map<String, dynamic> command) {
    if (!_connected || _socket == null) return;

    _socket!.add(jsonEncode(command));
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();

    _heartbeatTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_socket?.readyState == WebSocket.open) {
        _socket!.add(jsonEncode({"type": RemoteCommandType.ping.name}));
      }
    });
  }

  void _startWatchdog() {
    _watchdogTimer?.cancel();

    _watchdogTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_lastSeen == null) return;

      final diff = DateTime.now().difference(_lastSeen!);

      if (diff > const Duration(seconds: inactivityTimeoutSeconds)) {
        _handleDisconnect();
      }
    });
  }

  void _handleDisconnect() {
    if (!_connected) return;

    _connected = false;
    _connectionController.add(false);

    _socket?.close();
    _socket = null;

    _heartbeatTimer?.cancel();
    _watchdogTimer?.cancel();

    if (!_manuallyClosed) {
      _scheduleReconnect();
    }
  }

  int _reconnectAttempt = 0;

  void _scheduleReconnect() {
    if (_host == null || _port == null) return;

    final delay = Duration(seconds: (2 * _reconnectAttempt).clamp(2, 30));

    _reconnectAttempt++;

    Future.delayed(delay, () {
      if (_manuallyClosed) return;
      connect(_host!, _port!);
    });
  }

  Future<void> disconnect() async {
    _manuallyClosed = true;

    _heartbeatTimer?.cancel();
    _watchdogTimer?.cancel();

    await _socket?.close();

    _socket = null;
    _connected = false;

    _connectionController.add(false);
  }

  void dispose() {
    _heartbeatTimer?.cancel();
    _watchdogTimer?.cancel();
    _connectionController.close();
    _socket?.close();
  }
}
