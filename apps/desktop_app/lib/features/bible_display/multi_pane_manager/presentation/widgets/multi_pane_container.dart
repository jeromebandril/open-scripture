import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/models/multi_pane_data.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../../core/app_state/fullscreen_cubit.dart';
import '../../../../../core/app_state/interface_visibility_cubit.dart';
import '../../../../../shared/theme/tokens.dart';
import '../../../../customizer/presentation/state/customizer_cubit.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../bible_pane/presentation/widgets/bible_pane.dart';
import '../pane_animation_constants.dart';
import '../state/multi_pane_manager_cubit.dart';

class MultiPaneContainer extends StatelessWidget {
  const MultiPaneContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return _PaneContainerDecoration(
      child: _PaneList(),
    );
  }
}

class _PaneContainerDecoration extends StatelessWidget {
  const _PaneContainerDecoration({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final enableCustom = context.select(
      (CustomizerCubit c) => c.state.pane.enableCustomTheme,
    );
    final offset = context.select(
      (CustomizerCubit c) => c.state.pane.widthAdjustmentOffset,
    );
    final isFullscreen = context.select((FullscreenCubit f) => f.state);
    final showMenuBar = context.select(
      (InterfaceVisibilityCubit i) => i.state.isToolbarVisible,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: isFullscreen && !showMenuBar
            ? null
            : const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.sm),
                topRight: Radius.circular(AppRadius.sm),
              ),
        color: enableCustom
            ? Theme.of(context)
                .extension<BiblePaneGeneralTheme>()!
                .backgroundColor
            : Theme.of(context).colorScheme.surface,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12 + offset),
        child: child,
      ),
    );
  }
}

class _PaneList extends StatefulWidget {
  const _PaneList();

  @override
  State<_PaneList> createState() => _PaneListState();
}

class _PaneListState extends State<_PaneList> with WindowListener {
  bool isResizing = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResize() {
    if (!isResizing) {
      setState(() => isResizing = true);
    }
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 120),
      () {
        if (mounted) {
          setState(() => isResizing = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gap = context.select(
      (CustomizerCubit c) => c.state.pane.splitscreenGap,
    );
    final showDivider = context.select(
      (CustomizerCubit c) => c.state.pane.showSplitscreenDivider,
    );

    return BlocSelector<MultiPaneManagerCubit, PaneManagerState,
        (List<PaneDescriptor>, int?)>(
      selector: (state) => (state.panes, state.removingPaneId),
      builder: (context, data) {
        final (panes, removingPaneId) = data;
        final cubit = context.read<MultiPaneManagerCubit>();
        final gapPx = gap.toDouble();

        return LayoutBuilder(builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final count = panes.length;

          // Each pane gets an equal share minus the gaps between them.
          // (dividers are 1px wide, accounted for by the gap setting)
          final paneWidth = count > 0
              ? (totalWidth - gapPx * (count - 1)) / count
              : totalWidth;

          double leftFor(int index) => index * (paneWidth + gapPx);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < panes.length; i++) ...[
                //
                // Pane slot
                //
                AnimatedPositioned(
                  key: ValueKey(panes[i].id),
                  left: leftFor(i),
                  top: 0,
                  bottom: 0,
                  width: paneWidth,
                  duration: isResizing ? Duration.zero : kPaneSwapDuration,
                  curve: kPaneAnimationCurve,
                  child: _AnimatedPaneSlot(
                    paneId: panes[i].id,
                    isRemoving: panes[i].id == removingPaneId,
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerDown: (_) => cubit.setActive(panes[i].id),
                      child: BiblePane(
                        uniqueId: panes[i].id,
                        blocComponents: cubit.paneBlocsFor(panes[i].id),
                      ),
                    ),
                  ),
                ),
                //
                // Divider
                //
                if (i != panes.length - 1 && showDivider)
                  AnimatedPositioned(
                    key: ValueKey('divider_$i'),
                    left: leftFor(i + 1) - gapPx / 2 - 0.5,
                    top: 0,
                    bottom: 0,
                    width: 1,
                    duration: isResizing ? Duration.zero : kPaneSwapDuration,
                    curve: kPaneAnimationCurve,
                    child: const VerticalDivider(
                      width: 1,
                      thickness: 3,
                    ),
                  ),
              ],
            ],
          );
        });
      },
    );
  }
}

/// ----------------------------------------------------------------------
/// AnimatedPaneSlot
/// ----------------------------------------------------------------------
///
/// Wraps a single pane and drives add/remove fade + scale transitions.
/// On first build it animates in; when [isRemoving] flips to true it
/// animates out (the cubit waits for [_kRemoveDuration] before emitting
/// the final state that drops this pane from the list).
class _AnimatedPaneSlot extends StatefulWidget {
  const _AnimatedPaneSlot({
    required this.paneId,
    required this.isRemoving,
    required this.child,
  });

  final int paneId;
  final bool isRemoving;
  final Widget child;

  @override
  State<_AnimatedPaneSlot> createState() => _AnimatedPaneSlotState();
}

class _AnimatedPaneSlotState extends State<_AnimatedPaneSlot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: kPaneAddDuration,
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedPaneSlot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRemoving && !oldWidget.isRemoving) {
      // Animate out - cubit must wait _kRemoveDuration before removing
      // this pane from state (see MultiPaneManagerCubit.removePane).
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
