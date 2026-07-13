import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import '../../../../../app/state/fullscreen_cubit.dart';
import '../../../../../app/state/interface_visibility_cubit.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/widgets/draggable_divider.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../../customizer/presentation/state/customizer_cubit.dart';
import '../../../bible_pane/presentation/widgets/bible_pane.dart';
import '../models/multi_pane_data.dart';
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

    return BlocSelector<MultiPaneManagerCubit, PaneManagerState,
        (List<PaneDescriptor>, int?)>(
      selector: (state) => (state.panes, state.removingPaneId),
      builder: (context, data) {
        final (panes, removingPaneId) = data;
        final gapPx = gap.toDouble();

        return LayoutBuilder(builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          // Strip all gap pixels so sizeFactor sums cleanly to 1.0
          final widthMinusGaps = totalWidth - gapPx * (panes.length - 1);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < panes.length; i++)
                ..._buildPane(
                  i: i,
                  panes,
                  count: panes.length,
                  gapPx: gapPx,
                  widthMinusGap: widthMinusGaps,
                  removingPaneId: removingPaneId,
                ),
              // test: center reference
              // Positioned(
              //     top: 0,
              //     left: 0,
              //     right: 0,
              //     child: Center(
              //       child: Container(
              //         height: 10,
              //         width: 10,
              //         color: Colors.red,
              //       ),
              //     ))
            ],
          );
        });
      },
    );
  }

  // Pixel width of pane [i], computed from its sizeFactor over the
  // gap-free available width. sizeFactor values always sum to 1.0.
  double _panePixelWidth(
    List<PaneDescriptor> panes,
    int i,
    double widthMinusGaps,
  ) =>
      panes[i].sizeFactor * widthMinusGaps;

  // Pixel offset from the Stack's left edge to pane [i].
  // Accumulates widths of all preceding panes plus their trailing gaps.
  double _paneLeft(
    List<PaneDescriptor> panes,
    int i,
    double widthMinusGaps,
    double gapPx,
  ) {
    double left = 0;
    for (int j = 0; j < i; j++) {
      left += _panePixelWidth(panes, j, widthMinusGaps) + gapPx;
    }
    return left;
  }

  List<Widget> _buildPane(
    List<PaneDescriptor> panes, {
    required int i,
    required int count,
    required double gapPx,
    required double widthMinusGap,
    required int? removingPaneId,
  }) {
    final cubit = context.read<MultiPaneManagerCubit>();
    final paneWidth = panes[i].sizeFactor * widthMinusGap;
    final left = _paneLeft(panes, i, widthMinusGap, gapPx);
    final isLast = i == panes.length - 1;

    double accumulated = 0;

    return [
      //
      // Pane slot
      //
      AnimatedPositioned(
        key: ValueKey(panes[i].id),
        left: left,
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
      // Sits in the gap between pane [i] and pane [i+1] and fills it
      // entirely so the hit area matches the visible gap.
      // Calls resizeAdjacentPanes so both neighbours adjust simultaneously,
      // keeping all sizeFactor values summed to 1.0.
      //
      if (!isLast)
        AnimatedPositioned(
          key: ValueKey('divider_$i'),
          left: left + paneWidth,
          top: 0,
          bottom: 0,
          width: gapPx,
          duration: isResizing ? Duration.zero : kPaneSwapDuration,
          curve: kPaneAnimationCurve,
          child: DraggableDivider(
            width: gapPx,
            onDragStart: () => setState(() => isResizing = true),
            onDragEnd: () => setState(() => isResizing = false),
            onDrag: (delta) {
              accumulated += delta;
              if (accumulated.abs() < 2) return;
              context.read<MultiPaneManagerCubit>().resizeAdjacentPanes(
                    leftPaneId: panes[i].id,
                    rightPaneId: panes[i + 1].id,
                    deltaFactor: delta / widthMinusGap,
                  );
              accumulated = 0;
            },
          ),
        ),
    ];
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
