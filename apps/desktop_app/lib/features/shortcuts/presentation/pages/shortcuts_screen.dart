import 'package:flutter/material.dart';

import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../domain/models/app_command_info.dart';
import '../models/app_command_shortcuts.dart';
import '../widgets/shortcut_view.dart';

class ShortcutsScreen extends StatelessWidget {
  const ShortcutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: appCommandGroups.length,
        itemBuilder: (_, i) {
          final group = appCommandGroups[i];
          final commands = group.commands.entries.toList();

          return SettingSection.builder(
            title: group.scope.displayName,
            itemCount: commands.length,
            itemBuilder: (context, i) {
              final info = commands[i];

              return Setting(
                  label: info.value.label,
                  description: info.value.description,
                  settingWidth: 250,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 24,
                    child:
                        ShortcutView(activator: appCommandShortcuts[info.key]),
                  ));
            },
          );
        },
      ),
    );
  }
}
