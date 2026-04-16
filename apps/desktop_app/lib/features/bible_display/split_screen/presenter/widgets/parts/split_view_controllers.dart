import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/pane_manager_cubit.dart';

class SplitscreenControls extends StatelessWidget {
  SplitscreenControls({super.key});

  final _controller = OverlayPortalController();
  final LayerLink layerLink = LayerLink();
  final double menuGap = 5;

  Widget _buildOverlay(BuildContext context, Size screenSize) {
    return BlockSemantics(
      blocking: true,
      child: Container(
        width: 360,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
            constraints: BoxConstraints.loose(Size(
              screenSize.width,
              screenSize.height * .2,
            )),
            child: const Row(
              spacing: 8,
              children: [
                ActivePaneIndicator(),
                Row(
                  children: [
                    AddPaneXButton(),
                    RemovePaneButton(),
                  ],
                ),
                Row(
                  children: [
                    MovePaneButton(direction: -1),
                    MovePaneButton(direction: 1),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: OverlayPortal.overlayChildLayoutBuilder(
          controller: _controller,
          overlayChildBuilder: (BuildContext context, info) {
            final screen = MediaQuery.of(context).size;
            final top = info.childSize.height + menuGap;

            return Stack(
              children: [
                // Full-screen barrier for outside taps
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _controller.hide();
                    },
                  ),
                ),
                CompositedTransformFollower(
                  link: layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0, top), // place under anchor
                  child: _buildOverlay(context, screen),
                ),
              ],
            );
          },
          child: IconButton(
              tooltip: 'Splitscreen',
              onPressed: () => _controller.isShowing
                  ? _controller.hide()
                  : _controller.show(),
              icon: Icon(Icons.splitscreen_rounded))),
    );
  }
}

class AddPaneXButton extends StatelessWidget {
  const AddPaneXButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      //tooltip: "Add new pane to the right",
      onPressed: () {
        context.read<PaneManagerCubit>().splitNewPane();
      },
      child: Row(
        spacing: 8,
        children: [
          Icon(Icons.add_circle_outlined),
          Text('Add'),
        ],
      ),
    );
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
        //tooltip: "Move pane to the ${direction == 1 ? 'right' : 'left'}",
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
      (PaneManagerCubit c) => c.state.activePaneId + 1,
    );

    return SizedBox(
        width: 40, height: 20, child: Center(child: Text('id: $activeId')));
  }
}

class RemovePaneButton extends StatelessWidget {
  const RemovePaneButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeId = context.select(
      (PaneManagerCubit c) => c.state.activePaneId,
    );

    return TextButton(
      //tooltip: "Close current active pane",
      onPressed: () {
        context.read<PaneManagerCubit>().closePane(activeId);
      },
      child: Row(
        spacing: 8,
        children: [
          Icon(Icons.remove_circle),
          Text('Remove'),
        ],
      ),
    );
  }
}
