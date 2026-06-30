import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/ui/inputs/path_input.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../state/bible_importer_settings_cubit/bible_importer_settings_cubit.dart';

class SwordPathSelector extends StatelessWidget {
  const SwordPathSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<BibleImporterSettingsCubit>()..loadSettings(),
      child: const _PathSelctor(),
    );
  }
}

class _PathSelctor extends StatelessWidget {
  const _PathSelctor();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleImporterSettingsCubit, BibleImporterSettingsState>(
      builder: (context, state) {
        return Setting(
            label: 'Sword installation path',
            description: 'Location of sword modules',
            settingWidth: 400,
            child: PathInput(
              initialPath: state.settings.swordInstallationPath,
              onPathChanged: (path) => context
                  .read<BibleImporterSettingsCubit>()
                  .updateInstallationPath(path),
            ));
      },
    );
  }
}
