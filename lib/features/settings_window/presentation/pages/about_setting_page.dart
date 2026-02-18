import 'package:flutter/material.dart';

class AboutSettingsPage extends StatelessWidget {
  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Open Scripture'),
        SizedBox(height: 8),
        Text('Version 2.0.0'),
        Divider(),
        Text('© 2026'),
      ],
    );
  }
}
