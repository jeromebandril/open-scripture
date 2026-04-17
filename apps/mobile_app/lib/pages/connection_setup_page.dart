import 'package:flutter/material.dart';

import '../injection_container.dart' as di;
import '../service/client_ws.dart';

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
                        onPressed: isConnecting
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;
                                _formKey.currentState!.save();

                                setState(() {
                                  isConnecting = true;
                                });

                                final result = await di
                                    .sl<RemoteWsClient>()
                                    .connect(ip!, int.parse(port!));

                                if (result == 0) {
                                  setState(() {
                                    isConnecting = false;
                                    isSuccess = true;
                                  });

                                  await Future.delayed(Duration(seconds: 1));
                                  // Connection successful, navigate to main page
                                  Navigator.pushReplacementNamed(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    '/main',
                                  );
                                } else {
                                  // Connection failed, show error message
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Failed to connect to desktop app',
                                      ),
                                    ),
                                  );
                                }

                                setState(() {
                                  isConnecting = false;
                                });
                              },
                        icon: isConnecting
                            ? null
                            : const Icon(Icons.cable_sharp, size: 28),
                        label: isConnecting
                            ? const CircularProgressIndicator()
                            : const Text('Connect Manually'),
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
              Center(
                child: AnimatedScale(
                  scale: 1,
                  duration: Duration(milliseconds: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 128,
                      ),
                      SizedBox(height: 12),
                      Text("Connected!"),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
