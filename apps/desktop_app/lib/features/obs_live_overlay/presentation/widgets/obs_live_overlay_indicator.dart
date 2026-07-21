import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/service_status_indicator_shell.dart';
import '../../../settings_window/presentation/models/settings_route.dart';
import '../../../settings_window/presentation/pages/settings_window.dart';
import '../../../window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import '../state/obs_live_overlay_cubit.dart';

class ObsLiveOverlayIndicator extends StatelessWidget {
  const ObsLiveOverlayIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObsLiveOverlayCubit, ObsLiveOverlayState>(
      builder: (context, state) {
        if (!state.isRunning) return const SizedBox.shrink();
        final ref = state.snapshot.items['ref'];

        return ServiceStatusIndicatorShell(
          tooltipMessage:
              'OBS Live Overlay is ${state.isRunning ? 'running' : 'off'}',
          text: ref != null && ref.visible ? ref.text : '<empty>',
          icon: Icons.live_tv_rounded,
          onTap: () {
            context.read<WindowStackManagerBloc>().add(
                  WindowStackManagerOpen.selfManaged(
                    widget: SettingsWindow(
                      initialPage: SettingsPage.obsLiveOverlay,
                    ),
                  ),
                );
          },
        );
      },
    );
  }
}
