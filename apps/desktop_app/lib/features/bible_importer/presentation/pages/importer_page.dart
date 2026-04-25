import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_scripture/features/bible_importer/presentation/widgets/importer.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';

const suggestedSources = [
  'https://eBible.org',
  'https://github.com/seven1m/open-bibles'
];

class ImporterPage extends StatelessWidget {
  const ImporterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: Column(
        children: [
          SettingSection(
            title: 'Importer',
            children: [
              const Text('Compatible bible formats: USFX, OSIS'),
              const ImporterWidget(),
            ],
          ),
          SettingSection(
            title: '',
            children: [
              Setting(
                  label: 'Suggested sources',
                  description: 'These sources are subject to changes',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: suggestedSources.map((e) => Text(e)).toList(),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
