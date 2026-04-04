import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';

import '../../../../../../shared/presentation/widgets/dot.dart';

class ActivePaneIndicator extends StatelessWidget {
  const ActivePaneIndicator({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return Dot(
      overrideGlowingColor: Theme.of(context).colorScheme.primary,
      glowing:
          id == context.select((PaneManagerCubit p) => p.state.activePaneId),
    );
  }
}
