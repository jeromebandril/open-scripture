import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../shared/enums/bible_repository_type.dart';
import '../../../../shared/widgets/ui/inputs/app_input_option.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../../sword/presentation/widgets/sword_path_selector.dart'
    if (dart.library.html) '../../../sword/presentation/widgets/sword_path_selector_stub.dart';

import '../state/bible_importer_cubit/bible_importer_cubit.dart';
import '../widgets/importer.dart';
import '../widgets/list_of_repositories.dart';

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
              SettingSection.single(
                title: 'Recommended repositories',
                child: const ListOfBibleRepositories(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
