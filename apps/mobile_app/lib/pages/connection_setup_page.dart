import 'package:flutter/material.dart';

import '../injection_container.dart' as di;
import '../services/client_ws.dart';
import 'qr_scanner_page.dart';

class ConnectionSetupPage extends StatefulWidget {
  const ConnectionSetupPage({super.key});

  @override
  State<ConnectionSetupPage> createState() => _ConnectionSetupPageState();
}

class _ConnectionSetupPageState extends State<ConnectionSetupPage> {
  final _formKey = GlobalKey<FormState>();

  String? ip;
  String? port;

  bool isConnecting = false;
  bool isSuccess = false;

  void _connect() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => isConnecting = true);

    di.sl<RemoteWsClient>().connectionStream.first.then(
      _handleConnectionResult,
    );
    di.sl<RemoteWsClient>().connect(ip!, int.parse(port!));
  }

  void _connectWithQrCode() async {
    final result = await Navigator.of(context).push<(String, int)>(
      MaterialPageRoute(builder: (_) => const QrScannerPage()),
    );
    if (result == null) return;
    final (host, port) = result;
    setState(() => isConnecting = true);
    di.sl<RemoteWsClient>().connectionStream.first.then(
      _handleConnectionResult,
    );
    di.sl<RemoteWsClient>().connect(host, port);
  }

  void _handleConnectionResult(ConnectionStatus status) async {
    if (!mounted) return;
    if (status.connected) {
      setState(() {
        isConnecting = false;
        isSuccess = true;
      });
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => isConnecting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(status.message ?? 'Failed to connect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 24,
          top: 48,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Connect to desktop app',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                // const Text(
                //   'Make sure your desktop app is running and both devices are on the same network.',
                // ),
                const SizedBox(height: 48),

                Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16,

                    children: [
                      TextFormField(
                        enabled: !isConnecting,
                        keyboardType: TextInputType.numberWithOptions(),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Server IP Address',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => ip = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'IP address is required';
                          }

                          final ipRegex = RegExp(
                            r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}$',
                          );

                          if (!ipRegex.hasMatch(value)) {
                            return 'Enter a valid IP address';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        enabled: !isConnecting,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Server Port',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => port = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Port is required';
                          }

                          final port = int.tryParse(value);
                          if (port == null || port < 1 || port > 65535) {
                            return 'Enter a valid port (1–65535)';
                          }

                          return null;
                        },
                      ),
                      ElevatedButton.icon(
                        onPressed: isConnecting ? null : _connect,
                        icon: isConnecting
                            ? null
                            : const Icon(Icons.link_rounded, size: 28),
                        label: isConnecting
                            ? const CircularProgressIndicator()
                            : const Text('Connect Manually'),
                      ),
                      ElevatedButton.icon(
                        onPressed: isConnecting ? null : _connectWithQrCode,
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        label: const Text('Scan QR Code'),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 48),
                // ElevatedButton.icon(
                //   onPressed: () {},
                //   icon: const Icon(Icons.qr_code_scanner_rounded, size: 24),
                //   label: const Text('Scan QR Code'),
                // ),
              ],
            ),

            if (isSuccess)
              Positioned.fill(
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.surface,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 400),
                    builder: (context, value, child) =>
                        Opacity(opacity: value, child: child),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 128,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Connected!',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
