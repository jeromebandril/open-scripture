import 'package:flutter/material.dart';
import 'package:open_scripture/features/shortcuts/domain/app_command.dart';
import 'package:open_scripture/features/shortcuts/presentation/widget/shortcut_view.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';

import '../models/app_command_shortcuts.dart';

class ShortcutsScreen extends StatelessWidget {
  const ShortcutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: SettingSection.builder(
        title: 'Shortcuts',
        itemCount: AppCommand.values.length -
            2, // TODO: make a better way to implement private global shortcuts
        itemBuilder: (_, i) {
          final info = appCommandInfo[AppCommand.values[i]]!;
          return Setting(
              label: info.label,
              description: info.description,
              settingWidth: 250,
              child: Container(
                alignment: Alignment.centerLeft,
                height: 40,
                child: ShortcutView(
                    activator: appCommandShortcuts[AppCommand.values[i]]),
              ));
        },
      ),
    );
  }
}
