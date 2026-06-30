import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../shared/enums/bible_repository_type.dart';
import '../../../../shared/widgets/ui/inputs/app_input_option.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../state/bible_importer_cubit/bible_importer_cubit.dart';
import '../widgets/importer.dart';
import '../widgets/list_of_repositories.dart';
import '../widgets/sword_path_selector.dart';

const _recommendedSources = [
  'https://eBible.org',
  'https://github.com/seven1m/open-bibles'
];

const _crosswireSources = [
  "https://www.crosswire.org/sword/modules/ModDisp.jsp?modType=Bibles",
  "https://ftp.crosswire.org/ftpmirror/pub/sword/raw/modules/texts/ztext/",
];

class ImporterPage extends StatelessWidget {
  const ImporterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BibleImporterCubit>(),
      child: Builder(builder: (context) {
        final targetType =
            context.select((BibleImporterCubit c) => c.state.targetType);

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(42, 0, 42, 42),
          child: Column(
            children: [
              SettingSection(
                title: 'Importer',
                children: [
                  Setting(
                    label: 'Import type',
                    description:
                        'Select what type of datasource you are importing to',
                    child: AppInputOption<BibleRepositoryType>(
                      value: targetType,
                      onChanged: (mode) => context
                          .read<BibleImporterCubit>()
                          .setTargetType(mode),
                      items: BibleRepositoryType.installableTypes
                          .map((m) => AppDropdownItem<BibleRepositoryType>(
                              value: m, label: m.label))
                          .toList(),
                    ),
                  ),
                  if (targetType == BibleRepositoryType.sword)
                    const SwordPathSelector(),
                  const ImporterWidget(),
                ],
              ),
              SettingSection(title: 'Recommended repositories', children: [
                const ListOfBibleRepositories(
                  urls: _recommendedSources,
                  description: 'Repositories for canonical installations.',
                ),
                const ListOfBibleRepositories(
                  urls: _crosswireSources,
                  description:
                      'Repositories for crosswire sword engine. The first link may not work.',
                ),
              ]),
            ],
          ),
        );
      }),
    );
  }
}
