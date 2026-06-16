import 'package:flutter/material.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_text.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';
import 'package:open_scripture/shared/widgets/ui/inputs/path_input.dart';

class SwordModulesManagerPage extends StatelessWidget {
  const SwordModulesManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
        child: SettingSection(
          title: 'Sword configs',
          children: [
            Setting(
                label: 'Installation folder',
                description: 'Where modules are dropped',
                child: PathInput())
          ],
        ));
  }
}
