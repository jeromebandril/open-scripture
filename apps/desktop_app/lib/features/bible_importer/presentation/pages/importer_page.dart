import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/enums/bible_repository_type.dart';
import '../../../../shared/presentation/widgets/ui/inputs/app_input_option.dart';
import '../../../../shared/presentation/widgets/ui/inputs/file_dropzone.dart';
import '../../../settings_window/presentation/widgets/setting_option.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../../sword/presentation/widgets/sword_path_selector.dart'
    if (dart.library.html) '../../../sword/presentation/widgets/sword_path_selector_stub.dart';

import '../state/bible_importer_cubit/bible_importer_cubit.dart';
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
              SettingSection.single(
                title: 'Importer',
                child: Column(
                  children: [
                    SettingOption(
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
                    if (targetType == BibleRepositoryType.sword) ...[
                      const SizedBox(height: AppSpacing.sm),
                      const Divider(),
                      const SizedBox(height: AppSpacing.sm),
                      const SwordPathSelector(),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    const _ImporterWidget(),
                  ],
                ),
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

class _ImporterWidget extends StatelessWidget {
  const _ImporterWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleImporterCubit, BibleImporterState>(
      builder: (context, state) {
        return FileDropZoneUi(
          isDragOver: false,
          isLoading: state.status == BibleImporterStatus.running,
          errorText: state.errorMessage,
          onChoosePressed: () {
            context.read<BibleImporterCubit>().pickFile();
          },
          label: BlocBuilder<BibleImporterCubit, BibleImporterState>(
            builder: (context, state) {
              if (state.targetType == BibleRepositoryType.sword) {
                return const Text(
                    'Choose a valid zip file from the official Crosswire Repository');
              }
              return const Text('Choose a usfx.zip or osis.xml file');
            },
          ),
        );
      },
    );
  }
}
