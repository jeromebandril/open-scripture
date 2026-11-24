import 'package:flutter/material.dart';

const double _lineThickness = 1;
const double _thumbThickness = 8;
const double _thumbLength = 32;

/// A divider line with a draggable thumb.
///
/// [axis] is the drag direction. [Axis.horizontal] draws a vertical line
/// between side by side panes, [Axis.vertical] draws a horizontal line
/// between stacked panes. Callbacks report the drag delta along [axis].
class DraggableDivider extends StatelessWidget {
  const DraggableDivider({
    super.key,
    this.axis = Axis.horizontal,
    this.gap = 1,
    this.onDrag,
    this.onDragStart,
    this.onDragEnd,
  });

  final Axis axis;

  /// Space the divider takes along [axis].
  final double gap;

  final ValueChanged<double>? onDrag;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;

  @override
  Widget build(BuildContext context) {
    final isHorizontal = axis == Axis.horizontal;

    return SizedBox(
      width: isHorizontal ? gap : null,
      height: isHorizontal ? null : gap,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          if (isHorizontal)
            VerticalDivider(
              width: gap,
              thickness: _lineThickness,
              indent: 0,
              endIndent: 0,
            )
          else
            Divider(
              height: gap,
              thickness: _lineThickness,
              indent: 0,
              endIndent: 0,
            ),
          // Lets the thumb overflow gaps smaller than itself.
          OverflowBox(
            minWidth: 0,
            minHeight: 0,
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: _Thumb(
              axis: axis,
              onDrag: onDrag,
              onDragStart: onDragStart,
              onDragEnd: onDragEnd,
            ),
          ),
        ],
      ),
    );
  }
}

class _Thumb extends StatefulWidget {
  const _Thumb({
    required this.axis,
    this.onDrag,
    this.onDragStart,
    this.onDragEnd,
  });

  final Axis axis;
  final ValueChanged<double>? onDrag;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;

  @override
  State<_Thumb> createState() => _ThumbState();
}

class _ThumbState extends State<_Thumb> {
  bool _isHovering = false;
  bool _isDragging = false;

  bool get _isHorizontal => widget.axis == Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    final isActive = _isHovering || _isDragging;

    final hitSize = _orient(
      widget.axis,
      dragExtent: _thumbThickness,
      lineExtent: _thumbLength,
    );
    final barSize = _orient(
      widget.axis,
      dragExtent: isActive ? _thumbThickness : _lineThickness,
      lineExtent: _thumbLength,
    );

    return MouseRegion(
      cursor: _isHorizontal
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.resizeRow,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: _isHorizontal ? _handleDragStart : null,
        onHorizontalDragUpdate: _isHorizontal ? _handleDragUpdate : null,
        onHorizontalDragEnd: _isHorizontal ? _handleDragEnd : null,
        onHorizontalDragCancel: _isHorizontal ? _handleDragCancel : null,
        onVerticalDragStart: _isHorizontal ? null : _handleDragStart,
        onVerticalDragUpdate: _isHorizontal ? null : _handleDragUpdate,
        onVerticalDragEnd: _isHorizontal ? null : _handleDragEnd,
        onVerticalDragCancel: _isHorizontal ? null : _handleDragCancel,
        child: SizedBox.fromSize(
          size: hitSize,
          child: Center(
            child: SizedBox.fromSize(
              size: barSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() => _isDragging = true);
    widget.onDragStart?.call();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    widget.onDrag?.call(_isHorizontal ? details.delta.dx : details.delta.dy);
  }

  void _handleDragEnd(DragEndDetails details) => _finishDrag();

  void _handleDragCancel() => _finishDrag();

  void _finishDrag() {
    setState(() => _isDragging = false);
    widget.onDragEnd?.call();
  }
}

/// Builds a size from an extent along the drag direction and one along the
/// line itself.
Size _orient(
  Axis dragAxis, {
  required double dragExtent,
  required double lineExtent,
}) {
  return dragAxis == Axis.horizontal
      ? Size(dragExtent, lineExtent)
      : Size(lineExtent, dragExtent);
}
