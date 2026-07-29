import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/settings/settings_cubit.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/service_status_indicator_shell.dart';
import '../../../settings_window/presentation/models/settings_route.dart';
import '../../../settings_window/presentation/pages/settings_window.dart';
import '../../../window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import '../../settings/overlay_settings.dart';
import '../state/obs_live_overlay_cubit.dart';

class ObsLiveOverlayIndicator extends StatelessWidget {
  const ObsLiveOverlayIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final enableManualCtrl = context.select(
        (SettingsCubit<OverlaySettings> s) => s.state.enableManualControl);

    return BlocBuilder<ObsLiveOverlayCubit, ObsLiveOverlayState>(
      builder: (context, state) {
        if (!state.isRunning) return const SizedBox.shrink();
        final ref = state.snapshot.items['ref'];

        final currentRefStr = ref != null && ref.visible ? ref.text : '<empty>';
        final pendingRefStr = state.pendingVerse?.toDisplayString();
        final showPendingStr = enableManualCtrl &&
            pendingRefStr != null &&
            pendingRefStr != currentRefStr;

        return ServiceStatusIndicatorShell(
          label: Row(
            spacing: AppSpacing.xs,
            children: [
              if (showPendingStr) ...[
                Text(pendingRefStr, style: textTheme.bodySmall),
                const Icon(LucideIcons.arrowRight, size: 12),
              ],
              Text(currentRefStr, style: textTheme.bodySmall),
            ],
          ),
          labelTooltipMessage: showPendingStr ? 'Update overlay' : null,
          onLabelPressed: showPendingStr
              ? () => context.read<ObsLiveOverlayCubit>().flushBuffer()
              : null,
          icon: Icons.live_tv_rounded,
          iconTooltipMessage: 'Open overlay settings',
          onIconPressed: () => context
              .read<WindowStackManagerBloc>()
              .add(WindowStackManagerOpen.selfManaged(
                  widget: SettingsWindow(
                initialPage: SettingsPage.obsLiveOverlay,
              ))),
        );
      },
    );
  }
}
