import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../shared/widgets/async_singleton_builder.dart';
import '../../../../shared/widgets/ui/inputs/path_input.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../state/sword_engine_settings_cubit.dart';

class SwordPathSelector extends StatelessWidget {
  const SwordPathSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncSingletonBuilder<SwordEngineSettingsCubit>(
      resolver: () => di.sl.getAsync<SwordEngineSettingsCubit>(),
      loadingBuilder: (_) => const Center(child: CircularProgressIndicator()),
      errorBuilder: (_, error, retry) =>
          Text(error.toString()), // TODO: Replace with a proper error widget
      builder: (context, cubit) {
        return BlocProvider.value(
          value: cubit..loadSettings(),
          child: const _PathSelector(),
        );
      },
    );
  }
}

class _PathSelector extends StatelessWidget {
  const _PathSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwordEngineSettingsCubit, SwordEngineSettingsState>(
      builder: (context, state) {
        return Setting(
            label: 'Sword installation path',
            description: 'Location of sword modules',
            settingWidth: 400,
            child: PathInput(
              initialPath: state.settings.modulesPath,
              onPathChanged: (path) => context
                  .read<SwordEngineSettingsCubit>()
                  .updateInstallationPath(path),
            ));
      },
    );
  }
}
