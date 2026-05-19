import 'dart:async';

import 'package:flutter/material.dart';

const _thumbWidth = 8.0;
const _thumbHeight = 32.0;
const _dividerThickness = 1.0;

class DraggableDivider extends StatefulWidget {
  const DraggableDivider({super.key, this.onDrag, this.width = 1});

  final Function(double delta)? onDrag;
  final double width;

  @override
  State<DraggableDivider> createState() => _DraggableDividerState();
}

class _DraggableDividerState extends State<DraggableDivider> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final thumbPositionY = constraints.maxHeight / 2;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          VerticalDivider(
            width: widget.width,
            thickness: _dividerThickness,
            indent: 0,
            endIndent: 0,
          ),
          Positioned(
              top: thumbPositionY,
              left: widget.width / 2 - _thumbWidth / 2 + _dividerThickness / 2,
              child: _Thumb(onDrag: widget.onDrag)),
        ],
      );
    });
  }
}

class _Thumb extends StatefulWidget {
  const _Thumb({this.onDrag});

  final Function(double delta)? onDrag;

  @override
  State<_Thumb> createState() => _ThumbState();
}

class _ThumbState extends State<_Thumb> {
  bool isHovering = false;
  bool isDragging = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isThumbActive = isHovering || isDragging;

    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      onEnter: (evt) => setState(() => isHovering = true),
      onExit: (evt) => setState(() => isHovering = false),
      child: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        child: Container(
          alignment: Alignment.center,
          width: _thumbWidth,
          height: _thumbHeight,
          child: Container(
            width: isThumbActive ? _thumbWidth : _dividerThickness,
            height: _thumbHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    widget.onDrag?.call(details.delta.dx);

    setState(() => isDragging = true);

    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 150),
      () {
        if (mounted) setState(() => isDragging = false);
      },
    );
  }
}
