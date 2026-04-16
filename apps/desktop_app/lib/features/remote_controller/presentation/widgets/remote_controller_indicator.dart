import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/presentation/widgets/dot.dart';
import '../cubit/remote_controller/remote_controller_cubit.dart';
import '../cubit/remote_controller_settings/remote_controller_settings_cubit.dart';

class RemoteControllerIndicator extends StatelessWidget {
  const RemoteControllerIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RemoteControllerSettingsCubit,
        RemoteControllerSettingsState, bool>(
      selector: (state) => state.settings.enableFeature,
      builder: (context, isEnabled) {
        if (!isEnabled) return const SizedBox.shrink();

        return BlocBuilder<RemoteControllerCubit, RemoteControllerState>(
          builder: (context, state) {
            return Tooltip(
              message:
                  'Remote Controller Server is ${state.isRunning ? 'running' : 'off'}',
              child: Dot(
                glowing: state.isRunning,
                overrideColor: Theme.of(context).colorScheme.onSurfaceVariant,
                overrideGlowingColor: Colors.red,
              ),
            );
          },
        );
      },
    );
  }
}
