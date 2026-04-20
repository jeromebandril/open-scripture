import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared/rc_protocol/rc_protocol.dart';

const int connectTimeoutSeconds = 15;
const int pingFrequencySeconds = 20;
const int inactivityTimeoutSeconds = 3000;

class RemoteWsClient {
  WebSocket? _socket;

  String? _host;
  int? _port;

  bool _manuallyClosed = false;

  bool _connected = false;
  bool get isConnected => _connected;

  DateTime? _lastSeen;

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

  void sendCommand(RemoteCommand command) {
    if (!_connected || _socket == null) return;

    _socket!.add(command.toRaw());
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
    final isDisconnectedByServer = _socket?.closeCode == 4003;

    _connected = false;
    _connectionController.add(false);

    _socket?.close();
    _socket = null;

    _watchdogTimer?.cancel();

    if (!_manuallyClosed && !isDisconnectedByServer) {
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

    _watchdogTimer?.cancel();

    await _socket?.close();

    _socket = null;
    _connected = false;

    _connectionController.add(false);
  }

  void dispose() {
    _watchdogTimer?.cancel();
    _connectionController.close();
    _socket?.close();
  }
}
