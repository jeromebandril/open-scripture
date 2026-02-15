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
    this.onZoom,
    super.key,
  });

  final Widget child;
  final double initialiSize;
  final Function(double scaleFactor)? onZoom;

  @override
  State<AdjustableTextSize> createState() => _AdjustableTextSizeState();
}

class _AdjustableTextSizeState extends State<AdjustableTextSize> {
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
    _focusNode = FocusNode(debugLabel: 'ZoomTextWrapper');
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    // Multiply the system scaler by your document zoom factor.
    final combined = TextScaler.linear(
      mq.textScaler.scale(1.0) * textScaleFactor,
    );

    return Listener(
      onPointerSignal: _onPointerSignal,
      onPointerPanZoomUpdate: _onPointerPanZoomUpdate,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) => isControlPressed,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _focusNode.requestFocus();
          },
          child: Focus(
            focusNode: _focusNode,
            //onKeyEvent: _onKeyEvent,
            child: MediaQuery(
              data: mq.copyWith(textScaler: combined),
              child: DefaultTextStyle.merge(
                style: TextStyle(fontSize: textSize),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// To handle trackpad zoom gestures
  void _onPointerPanZoomUpdate(PointerPanZoomUpdateEvent event) {
    if (event.scale == 1) return;

    if (event.scale > 1)  {
      _zoom(1);
    } else {
      _zoom(-1);
    } 
  }

  // HardwareKeyboard.instance.isControlPressed instead
  KeyEventResult _onKeyEvent(_, event) {
    // handle zoom activation only if ctrl is pressed
    if (event.logicalKey != LogicalKeyboardKey.controlLeft &&
        event.logicalKey != LogicalKeyboardKey.controlRight) {
      return KeyEventResult.ignored;
    }
    if (event is KeyDownEvent && !isControlPressed) isControlPressed = true;
    if (event is KeyUpEvent && isControlPressed) isControlPressed = false;

    return KeyEventResult.handled;
  }

  /// To handle zooming with scroll wheel
  void _onPointerSignal(PointerSignalEvent signal) {
    if (HardwareKeyboard.instance.isControlPressed &&
        signal is PointerScrollEvent) {
      // * prevent a possible scrollable child to scroll while zooming:
      // by jumping to the initial offset of when ctrl was pressed
      signal.scrollDelta.dy < 0 ? _zoom(1) : _zoom(-1);

      GestureBinding.instance.pointerSignalResolver.register(signal,
          (PointerSignalEvent e) {
        signal.scrollDelta.dy < 0 ? _zoom(1) : _zoom(-1);
      });
    }
  }

  void _zoom(int n) {
    setState(() {
      textScaleFactor = (textScaleFactor + sensitivity * n).clamp(
        lowerLimit,
        highestLimit,
      );
      widget.onZoom?.call(textScaleFactor);
    });
  }
}
