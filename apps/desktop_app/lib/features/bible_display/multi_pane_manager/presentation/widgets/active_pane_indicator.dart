import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/widgets/dot.dart';
import '../state/multi_pane_manager_cubit.dart';

class ActivePaneIndicator extends StatelessWidget {
  const ActivePaneIndicator({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return Dot(
      overrideColor: Theme.of(context).colorScheme.surfaceBright,
      overrideGlowingColor: Theme.of(context).colorScheme.primary,
      glowing: id ==
          context.select((MultiPaneManagerCubit p) => p.state.activePaneId),
    );
  }
}
