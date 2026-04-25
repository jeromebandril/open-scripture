import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/state/obs_overlay_settinsg/obs_live_overlay_settings_cubit.dart';

import '../../../../shared/widgets/dot.dart';
import '../state/obs_overlay/obs_live_overlay_cubit.dart';

class ObsLiveOverlayIndicator extends StatelessWidget {
  const ObsLiveOverlayIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ObsLiveOverlaySettingsCubit,
        ObsLiveOverlaySettingsState, bool>(
      selector: (state) => state.settings.enableFeature,
      builder: (context, isEnabled) {
        if (!isEnabled) return const SizedBox.shrink();

        return BlocBuilder<ObsLiveOverlayCubit, ObsLiveOverlayState>(
          builder: (context, state) {
            return Tooltip(
              message:
                  'OBS Live Overlay is ${state.isRunning ? 'running' : 'off'}',
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
