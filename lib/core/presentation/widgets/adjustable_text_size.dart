import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const sensitivity = 0.05;
const lowerLimit = 1.0;
const highestLimit = 10.0;

class AdjustableTextSize extends StatefulWidget {
  /// The sub-widget tree below this will inherit
  /// the text size of this widget, which can be
  /// set with mouse wheel scrolling + scroll
  /// or with trackpad pan
  ///
  /// Pass a [ScrollController], if in this sub-tree
  /// is present a scrollable widget, to prevent
  /// it to scroll while zooming
  const AdjustableTextSize({
    required this.child,
    required this.initialiSize,
    this.scrollController,
    this.onZoom,
    super.key,
  });

  final Widget child;
  final double initialiSize;
  final ScrollController? scrollController;
  final Function(double scaleFactor)? onZoom;

  @override
  State<AdjustableTextSize> createState() => _AdjustableTextSizeState();
}

class _AdjustableTextSizeState extends State<AdjustableTextSize> {
  ScrollController? scrollController;
  late double textSize;
  double textScaleFactor = 1.0;
  bool isControlPressed = false;
  bool isChildListScrolling = false;
  double scrollOffset = 0;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    textSize = widget.initialiSize;
    scrollController = widget.scrollController;
    _focusNode = FocusNode(debugLabel: 'ZoomTextWrapper');
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: _onPointerSignal,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          print('focus requested');
          _focusNode.requestFocus();
        },
        onScaleUpdate: _onScaleUpdate,
        child: Focus(
          focusNode: _focusNode,
          onKeyEvent: _onKeyEvent,
          child: DefaultTextStyle.merge(
            style: TextStyle(fontSize: textSize * textScaleFactor),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  /// To handle trackpad zoom gestures
  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.rotation == 0) return;
    details.scale > 1 ? _zoom(1) : _zoom(-1);
  }

  KeyEventResult _onKeyEvent(_, event) {
    // handle zoom activation only if ctrl is pressed
    if (event.logicalKey != LogicalKeyboardKey.controlLeft &&
        event.logicalKey != LogicalKeyboardKey.controlRight) {
      return KeyEventResult.ignored;
    }
    if (event is KeyDownEvent) isControlPressed = true;
    if (event is KeyUpEvent) isControlPressed = false;

    // * prevent a possible scrollable child to scroll while zomming:
    // when pressing ctrl, save the scroll offset
    if (scrollController != null && isControlPressed) {
      scrollOffset = scrollController!.offset;
    }
    return KeyEventResult.handled;
  }

  /// To handle zooming with scroll wheel
  void _onPointerSignal(PointerSignalEvent signal) {
    if (isControlPressed && signal is PointerScrollEvent) {
      // * prevent a possible scrollable child to scroll while zooming:
      // by jumping to the initial offset of when ctrl was pressed
      _prevetNormalScroll();
      signal.scrollDelta.dy < 0 ? _zoom(1) : _zoom(-1);
    }
  }

  void _zoom(int n) {
    setState(() {
      textScaleFactor = (textScaleFactor + sensitivity * n).clamp(
        lowerLimit,
        highestLimit,
      );
      if (widget.onZoom != null) widget.onZoom!(textScaleFactor);
    });
  }

  void _prevetNormalScroll() {
    scrollController!.jumpTo(scrollOffset);
  }
}
