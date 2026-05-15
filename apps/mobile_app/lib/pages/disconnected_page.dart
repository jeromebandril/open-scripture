import 'dart:async';

import 'package:flutter/material.dart';

import '../injection_container.dart' as di;
import '../services/client_ws.dart';

class DisconnectedPage extends StatefulWidget {
  const DisconnectedPage({super.key, required this.initialMessage});

  final String initialMessage;

  @override
  State<DisconnectedPage> createState() => _DisconnectedPageState();
}

class _DisconnectedPageState extends State<DisconnectedPage> {
  StreamSubscription<ConnectionStatus>? _statusSub;
  String? _message;

  @override
  void initState() {
    super.initState();
    _message = widget.initialMessage;
    _statusSub = di.sl<RemoteWsClient>().connectionStream.listen((status) {
      if (status.connected) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          _message = status.message ?? 'You are disconnected.';
        });
      }
    });
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.signal_wifi_connected_no_internet_4_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          Text(
            _message!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () => di.sl<RemoteWsClient>().reconnect(),
                icon: const Icon(Icons.refresh),
                label: const Text('Reconnect'),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/setup');
                },
                icon: const Icon(Icons.connected_tv_rounded),
                label: const Text('New Connection'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
