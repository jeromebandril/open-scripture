import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'draggable_divider.dart';

/// Describes one pane of a [SplitPaneView].
@immutable
class SplitPaneEntry<Id extends Object> {
  const SplitPaneEntry({required this.id, required this.sizeFactor});

  final Id id;

  /// Share of the available space. Factors of all entries should sum to 1.0.
  final double sizeFactor;

  SplitPaneEntry<Id> copyWith({Id? id, double? sizeFactor}) {
    return SplitPaneEntry(
      id: id ?? this.id,
      sizeFactor: sizeFactor ?? this.sizeFactor,
    );
  }
}

typedef SplitPaneBuilder<Id extends Object> = Widget Function(
  BuildContext context,
  Id id,
);

/// [startId] is the left pane when horizontal and the top pane when vertical.
typedef SplitPaneResizeCallback<Id extends Object> = void Function(
  Id startId,
  Id endId,
  double deltaFactor,
);

/// Lays out panes in a row or a column with draggable dividers between them.
///
/// The parent owns the sizes: it passes [entries] in and applies the changes
/// requested through [onResize]. To remove a pane with an exit animation, set
/// [removingId] first, then drop the entry from [entries] once
/// [transitionDuration] has elapsed.
class SplitPaneView<Id extends Object> extends StatefulWidget {
  const SplitPaneView({
    super.key,
    required this.entries,
    required this.paneBuilder,
    required this.onResize,
    this.axis = Axis.horizontal,
    this.removingId,
    this.gap = 8,
    this.moveDuration = const Duration(milliseconds: 250),
    this.transitionDuration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });

  final List<SplitPaneEntry<Id>> entries;
  final SplitPaneBuilder<Id> paneBuilder;
  final SplitPaneResizeCallback<Id> onResize;

  /// [Axis.horizontal] splits left to right, [Axis.vertical] top to bottom.
  final Axis axis;

  final Id? removingId;

  /// Space between panes. Also the hit area of each divider.
  final double gap;

  /// Duration of position and size changes.
  final Duration moveDuration;

  /// Duration of the fade and scale when a pane is added or removed.
  final Duration transitionDuration;

  final Curve curve;

  @override
  State<SplitPaneView<Id>> createState() => _SplitPaneViewState<Id>();
}

class _SplitPaneViewState<Id extends Object> extends State<SplitPaneView<Id>> {
  static const double _dragThreshold = 2;

  bool _isDragging = false;
  double _pendingDelta = 0;
  double? _lastExtent;

  bool get _isHorizontal => widget.axis == Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalExtent =
            _isHorizontal ? constraints.maxWidth : constraints.maxHeight;
        assert(totalExtent.isFinite, 'SplitPaneView needs bounded space.');

        // An extent change means the window or its padding changed, so panes
        // must follow immediately instead of animating.
        final extentChanged = _lastExtent != null && _lastExtent != totalExtent;
        _lastExtent = totalExtent;

        final moveDuration =
            _isDragging || extentChanged ? Duration.zero : widget.moveDuration;

        return Stack(
          clipBehavior: Clip.none,
          children: _buildChildren(totalExtent, moveDuration),
        );
      },
    );
  }

  List<Widget> _buildChildren(double totalExtent, Duration moveDuration) {
    final entries = widget.entries;
    final gap = widget.gap;

    // Gaps are removed first so the size factors sum cleanly to 1.0.
    final gapCount = math.max(0, entries.length - 1);
    final available = math.max(0.0, totalExtent - gap * gapCount);

    final panes = <Widget>[];
    final dividers = <Widget>[];
    var offset = 0.0;

    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final paneExtent = entry.sizeFactor * available;

      panes.add(
        _slot(
          key: ValueKey(entry.id),
          offset: offset,
          extent: paneExtent,
          duration: moveDuration,
          child: _PaneTransition(
            isRemoving: entry.id == widget.removingId,
            duration: widget.transitionDuration,
            child: widget.paneBuilder(context, entry.id),
          ),
        ),
      );

      if (i < entries.length - 1) {
        dividers.add(
          _slot(
            key: ValueKey(('divider', entry.id)),
            offset: offset + paneExtent,
            extent: gap,
            duration: moveDuration,
            child: _buildDivider(
              startId: entry.id,
              endId: entries[i + 1].id,
              available: available,
            ),
          ),
        );
      }

      offset += paneExtent + gap;
    }

    // Dividers are added last so they sit above the panes.
    return [...panes, ...dividers];
  }

  /// Places a child along the main axis and stretches it on the cross axis.
  Widget _slot({
    required Key key,
    required double offset,
    required double extent,
    required Duration duration,
    required Widget child,
  }) {
    final horizontal = _isHorizontal;

    return AnimatedPositioned(
      key: key,
      left: horizontal ? offset : 0,
      right: horizontal ? null : 0,
      top: horizontal ? 0 : offset,
      bottom: horizontal ? 0 : null,
      width: horizontal ? extent : null,
      height: horizontal ? null : extent,
      duration: duration,
      curve: widget.curve,
      child: child,
    );
  }

  Widget _buildDivider({
    required Id startId,
    required Id endId,
    required double available,
  }) {
    void onDrag(double delta) => _handleDrag(
          delta,
          startId: startId,
          endId: endId,
          available: available,
        );

    return DraggableDivider(
      axis: widget.axis,
      gap: widget.gap,
      onDragStart: _handleDragStart,
      onDragEnd: _handleDragEnd,
      onDrag: onDrag,
    );
  }

  void _handleDragStart() {
    _pendingDelta = 0;
    setState(() => _isDragging = true);
  }

  void _handleDragEnd() {
    setState(() => _isDragging = false);
  }

  void _handleDrag(
    double delta, {
    required Id startId,
    required Id endId,
    required double available,
  }) {
    if (available <= 0) return;

    _pendingDelta += delta;
    if (_pendingDelta.abs() < _dragThreshold) return;

    widget.onResize(startId, endId, _pendingDelta / available);
    _pendingDelta = 0;
  }
}

/// Fades and scales its child in on first build and out when [isRemoving]
/// becomes true.
class _PaneTransition extends StatefulWidget {
  const _PaneTransition({
    required this.isRemoving,
    required this.duration,
    required this.child,
  });

  final bool isRemoving;
  final Duration duration;
  final Widget child;

  @override
  State<_PaneTransition> createState() => _PaneTransitionState();
}

class _PaneTransitionState extends State<_PaneTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curved;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _curved = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.94, end: 1).animate(_curved);
    _controller.forward();
  }

  @override
  void didUpdateWidget(_PaneTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRemoving == oldWidget.isRemoving) return;

    if (widget.isRemoving) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _curved.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curved,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
