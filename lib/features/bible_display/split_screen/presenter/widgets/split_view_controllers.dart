import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/pane_manager_cubit.dart';

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
