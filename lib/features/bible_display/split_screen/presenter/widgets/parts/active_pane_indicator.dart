import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';

class ActivePaneIndicator extends StatelessWidget {
  const ActivePaneIndicator({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return Dot(
      glowing:
          id == context.select((PaneManagerCubit p) => p.state.activePaneId),
    );
  }
}

class Dot extends StatelessWidget {
  final bool glowing;

  const Dot({
    super.key,
    this.glowing = false,
  });

  @override
  Widget build(BuildContext context) {
    double size = glowing ? 12 : 8;

    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: glowing ? Colors.white : Colors.white38,
      ),
    );
  }
}
