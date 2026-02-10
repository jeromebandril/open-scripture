import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/presentation/widgets/dot.dart';
import '../cubit/obs_live_overlay_cubit.dart';

class ObsLiveOverlayIndicator extends StatelessWidget {
  const ObsLiveOverlayIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObsLiveOverlayCubit, ObsLiveOverlayState>(
      builder: (context, state) {
        return Dot(
          glowing: state.isRunning,
          overrideGlowingColor: Colors.red,
          tooltipMessage:
              'OBS Live Overlay ${state.isRunning ? 'running' : 'off'}',
        );
      },
    );
  }
}
