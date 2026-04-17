import 'package:flutter/material.dart';
import 'package:shared/models/remote_command_type.dart';

import '../injection_container.dart' as di;
import '../service/client_ws.dart';

class CommandGrid extends StatelessWidget {
  const CommandGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final commands = [
      {
        "text": "Zoom In",
        "icon": Icons.zoom_in,
        "payload": {"zoom_in": 1},
      },
      {
        "text": "Zoom Out",
        "icon": Icons.zoom_out,
        "payload": {"zoom_out": 1},
      },
      {
        "text": "Prev",
        "icon": Icons.navigate_before_rounded,
        "payload": {"zoom_out": 1},
      },
      {
        "text": "Next",
        "icon": Icons.navigate_next_rounded,
        "payload": {"zoom_in": 1},
      },
      {
        "text": "Switch to list view",
        "icon": Icons.view_headline_rounded,
        "payload": {"zoom_in": 1},
      },
      {
        "text": "Switch to big view",
        "icon": Icons.view_column,
        "payload": {"zoom_in": 1},
      },
    ];

    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      childAspectRatio: 1.8,
      children: commands.map((cmd) {
        return ElevatedButton.icon(
          iconAlignment: IconAlignment.end,
          icon: Icon(cmd["icon"] as IconData, size: 32),
          label: Text(
            cmd["text"] as String,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () {
            di.sl<RemoteWsClient>().sendCommand({
              "id": 'mobile-test',
              "target": "pane",
              "type": RemoteCommandType.action.name,
              "payload": cmd["payload"],
            });
          },
        );
      }).toList(),
    );
  }
}
