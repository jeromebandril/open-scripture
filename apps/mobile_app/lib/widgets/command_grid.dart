import 'package:flutter/material.dart';
import 'package:shared/rc_protocol/rc_protocol.dart';

import '../injection_container.dart' as di;
import '../services/client_ws.dart';

const commands = [
  {
    "text": "Zoom Out",
    'name': 'zoom_out',
    'target': 'pane',
    "type": RemoteCommandType.custom,
    "icon": Icons.zoom_out,
    "payload": {"multiplier": 2.0},
  },
  {
    "text": "Zoom In",
    'name': 'zoom_in',
    'target': 'pane',
    "type": RemoteCommandType.custom,
    "icon": Icons.zoom_in,
    "payload": {"multiplier": 2.0},
  },
  {
    "text": "Prev",
    'name': 'go_prev_verse',
    "type": RemoteCommandType.command,
    "icon": Icons.navigate_before_rounded,
  },
  {
    "text": "Next",
    'name': 'go_next_verse',
    "type": RemoteCommandType.command,
    "icon": Icons.navigate_next_rounded,
  },
  {
    "text": "Switch to list view",
    'name': 'switch_display_mode',
    'target': 'pane',
    "type": RemoteCommandType.custom,
    "icon": Icons.view_headline_rounded,
    "payload": {"display_mode": 0},
  },
  {
    "text": "Switch to big view",
    "name": 'switch_display_mode',
    'target': 'pane',
    "type": RemoteCommandType.custom,
    "icon": Icons.view_column,
    "payload": {"display_mode": 1},
  },
];

class CommandGrid extends StatelessWidget {
  const CommandGrid({super.key});

  @override
  Widget build(BuildContext context) {
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
            di.sl<RemoteWsClient>().sendCommand(
              RemoteCommand(
                id: 'mobile-test',
                type: cmd['type'] as RemoteCommandType,
                name: cmd['name'] as String,
                target: cmd['target'] as String?,
                payload: cmd["payload"] as Map<String, dynamic>?,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
