import 'package:flutter/material.dart';
import 'package:open_scripture/features/bible_importer/presentation/widgets/importer.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';
import 'package:open_scripture/shared/theme/tokens.dart';
import 'package:url_launcher/url_launcher.dart';

const _recommendedSources = [
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
              title: 'Recommended repositories',
              children: [const _ListOfBibleRepositories()]),
        ],
      ),
    );
  }
}

class _ListOfBibleRepositories extends StatelessWidget {
  const _ListOfBibleRepositories();

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xs,
        children: _recommendedSources
            .map(
              (e) => Material(
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  hoverColor: Theme.of(context).colorScheme.primaryContainer,
                  onTap: () async => await launchUrl(Uri.parse(e)),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                        // color: Theme.of(context).colorScheme.surfaceContainer,
                        ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e),
                        Icon(
                          Icons.open_in_new,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 16,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList());
  }
}
