import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/shared/widgets/service_status_indicator_shell.dart';

import '../../../settings_window/presentation/models/settings_route.dart';
import '../../../settings_window/presentation/pages/settings_window.dart';
import '../../../window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import '../state/remote_controller/remote_controller_cubit.dart';

class RemoteControllerIndicator extends StatelessWidget {
  const RemoteControllerIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteControllerCubit, RemoteControllerState>(
      builder: (context, state) {
        if (!state.isRunning) return SizedBox.shrink();

        return ServiceStatusIndicatorShell(
          tooltipMessage: 'Remote Controller Enabled',
          text: state.connectedClients.length.toString(),
          icon: Icons.stay_current_portrait_rounded,
          onTap: () {
            context.read<WindowStackManagerBloc>().add(
                  WindowStackManagerOpen.selfManaged(
                    widget: SettingsWindow(
                      initialRoute: SettingsSection.remoteController,
                    ),
                  ),
                );
          },
        );
      },
    );
  }
}
