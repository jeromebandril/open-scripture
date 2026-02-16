import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/presentation/widgets/dot.dart';
import '../cubit/obs_overlay/obs_live_overlay_cubit.dart';

class ObsLiveOverlayIndicator extends StatelessWidget {
  const ObsLiveOverlayIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObsLiveOverlayCubit, ObsLiveOverlayState>(
      builder: (context, state) {
        return Tooltip(
          message: 'OBS Live Overlay is ${state.isRunning ? 'running' : 'off'}',
          child: Dot(
            glowing: state.isRunning,
            overrideGlowingColor: Colors.red,
          ),
        );
      },
    );
  }
}
