import 'package:flutter/material.dart';
import 'package:the_smyrna_bible_v2/features/keybindings/domain/app_command.dart';
import 'package:the_smyrna_bible_v2/features/keybindings/presentation/widget/parts/shortcut_view.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_section.dart';

class KeybindingsScreen extends StatelessWidget {
  const KeybindingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 0),
      child: SettingSection.builder(
        title: 'Keybindings',
        itemCount: AppCommand.values.length,
        itemBuilder: (_, i) {
          final info = appCommandInfo[AppCommand.values[i]]!;
          return Setting(
              label: info.label,
              description: info.description,
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
