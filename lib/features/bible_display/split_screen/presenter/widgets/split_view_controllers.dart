import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/pane_manager_cubit.dart';

class SplitscreenControls extends StatefulWidget {
  const SplitscreenControls({super.key});

  @override
  State<SplitscreenControls> createState() => _SplitscreenControlsState();
}

class _SplitscreenControlsState extends State<SplitscreenControls> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return _expanded
        ? Row(
            children: [
              IconButton(
                  onPressed: () => setState(() => _expanded = false),
                  icon: Icon(Icons.expand_circle_down_rounded)),
              const ActivePaneIndicator(),
              const AddPaneXButton(),
              const RemovePaneButton(),
              const MovePaneButton(direction: -1),
              const MovePaneButton(direction: 1),
            ],
          )
        : IconButton(
            onPressed: () => setState(() => _expanded = true),
            icon: Icon(Icons.splitscreen_rounded));
  }
}

class AddPaneXButton extends StatelessWidget {
  const AddPaneXButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: "Add new pane to the right",
        onPressed: () {
          context.read<PaneManagerCubit>().splitNewPane();
        },
        icon: Icon(Icons.add_circle_outlined));
  }
}

class MovePaneButton extends StatelessWidget {
  final int direction;
  const MovePaneButton({required this.direction, super.key});

  @override
  Widget build(BuildContext context) {
    final activeId = context.select(
      (PaneManagerCubit c) => c.state.activePaneId,
    );
    final panes = context.select(
      (PaneManagerCubit c) => c.state.panes,
    );

    return IconButton(
        tooltip: "Move pane to the ${direction == 1 ? 'right' : 'left'}",
        onPressed: () {
          final index = panes.indexWhere((p) => p.id == activeId) + direction;
          if (index == -1) return;
          context.read<PaneManagerCubit>().swapPanes(
                activeId,
                panes[index].id,
              );
        },
        icon: Icon(direction == 1 ? Icons.arrow_forward : Icons.arrow_back));
  }
}

class ActivePaneIndicator extends StatelessWidget {
  const ActivePaneIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final activeId = context.select(
      (PaneManagerCubit c) => c.state.activePaneId,
    );

    return Text(activeId.toString());
  }
}

class RemovePaneButton extends StatelessWidget {
  const RemovePaneButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeId = context.select(
      (PaneManagerCubit c) => c.state.activePaneId,
    );

    return IconButton(
        tooltip: "Close current active pane",
        onPressed: () {
          context.read<PaneManagerCubit>().closePane(activeId);
        },
        icon: Icon(Icons.remove_circle));
  }
}
