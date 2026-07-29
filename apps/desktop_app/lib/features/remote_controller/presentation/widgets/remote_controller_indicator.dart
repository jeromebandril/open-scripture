import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/service_status_indicator_shell.dart';

import '../../../settings_window/presentation/models/settings_route.dart';
import '../../../settings_window/presentation/pages/settings_window.dart';
import '../../../window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import '../state/remote_controller_cubit.dart';

class RemoteControllerIndicator extends StatelessWidget {
  const RemoteControllerIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteControllerCubit, RemoteControllerState>(
      builder: (context, state) {
        if (!state.isRunning) return SizedBox.shrink();

        return ServiceStatusIndicatorShell(
          iconTooltipMessage: 'Open remote controller settings',
          label: Text(
            state.connectedClients.length.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          icon: Icons.stay_current_portrait_rounded,
          onIconPressed: () {
            context.read<WindowStackManagerBloc>().add(
                  WindowStackManagerOpen.selfManaged(
                    widget: SettingsWindow(
                      initialPage: SettingsPage.remoteController,
                    ),
                  ),
                );
          },
        );
      },
    );
  }
}
