import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/shared/theme/tokens.dart';

import '../../../settings_window/presentation/models/settings_route.dart';
import '../../../settings_window/presentation/pages/settings_window.dart';
import '../../../window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
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
            return InkWell(
              mouseCursor: SystemMouseCursors.click,
              onTap: () {
                context.read<WindowStackManagerBloc>().add(
                      WindowStackManagerOpen.selfManaged(
                        widget: SettingsWindow(
                          initialRoute: SettingsSection.remoteController,
                        ),
                      ),
                    );
              },
              child: Tooltip(
                message: 'Remote Controller Enabled',
                child: Container(
                  height: 32,
                  width: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: AppSpacing.xs,
                    children: [
                      Text(
                        state.connectedClients.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Icon(
                        Icons.stay_current_portrait_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
