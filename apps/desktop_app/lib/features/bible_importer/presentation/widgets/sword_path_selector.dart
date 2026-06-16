import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/core/di/injection_container.dart';
import 'package:open_scripture/features/bible_importer/presentation/state/bible_importer_settings_cubit/bible_importer_settings_cubit.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting.dart';
import 'package:open_scripture/shared/widgets/ui/inputs/path_input.dart';

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
        print('this is the path: ${state.settings.swordInstallationPath}');
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
