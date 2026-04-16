import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/text_scaler/cubit/text_scaler_cubit.dart';

import '../../../../injection_container.dart';

const sensitivity = 0.05;
const lowerLimit = 1.0;
const highestLimit = 10.0;

class TextScalerHost extends StatefulWidget {
  /// The sub-widget tree below this will inherit
  /// the text size of this widget, which can be
  /// set with mouse wheel scrolling + scroll
  /// or with trackpad pan
  ///
  /// Pass a [ScrollController], if in this sub-tree
  /// is present a scrollable widget, to prevent
  /// it to scroll while zooming
  const TextScalerHost({
    required this.child,
    required this.initialiSize,
    this.textScalerCubit,
    this.onZoom,
    super.key,
  });

  final Widget child;
  final double initialiSize;
  final TextScalerCubit? textScalerCubit;
  final Function(double scaleFactor)? onZoom;

  @override
  State<TextScalerHost> createState() => _TextScalerHostState();
}

class _TextScalerHostState extends State<TextScalerHost> {
  late final TextScalerCubit _textScalerCubit;
  late double textSize;
  double textScaleFactor = 1.0;
  bool isControlPressed = false;
  bool isChildListScrolling = false;
  double scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    textSize = widget.initialiSize;
    _textScalerCubit = widget.textScalerCubit ?? sl<TextScalerCubit>();
  }

  @override
  void dispose() {
    // Close the cubit only if it was created by this widget,
    // otherwise it might be used by other TextScalerHost widgets
    if (widget.textScalerCubit == null) {
      _textScalerCubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _textScalerCubit,
      child: Listener(
        onPointerSignal: _onPointerSignal,
        onPointerPanZoomUpdate: _onPointerPanZoomUpdate,
        child: NotificationListener<ScrollNotification>(
          onNotification: (n) => isControlPressed,
          child: BlocBuilder<TextScalerCubit, TextScalerState>(
            builder: (context, state) {
              final mq = MediaQuery.of(context);

              final combined = TextScaler.linear(
                mq.textScaler.scale(1.0) * state.textScaleFactor,
              );

              return MediaQuery(
                data: mq.copyWith(textScaler: combined),
                child: DefaultTextStyle.merge(
                  style: TextStyle(fontSize: textSize),
                  child: widget.child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// To handle trackpad zoom gestures
  void _onPointerPanZoomUpdate(PointerPanZoomUpdateEvent event) {
    if (event.scale == 1) return;

    if (event.scale > 1) {
      _textScalerCubit.zoomIn();
    } else {
      _textScalerCubit.zoomOut();
    }
  }

  /// To handle zooming with scroll wheel
  void _onPointerSignal(PointerSignalEvent signal) {
    if (HardwareKeyboard.instance.isControlPressed &&
        signal is PointerScrollEvent) {
      // * prevent a possible scrollable child to scroll while zooming:
      // by jumping to the initial offset of when ctrl was pressed
      signal.scrollDelta.dy < 0
          ? _textScalerCubit.zoomIn()
          : _textScalerCubit.zoomOut();

      GestureBinding.instance.pointerSignalResolver.register(signal,
          (PointerSignalEvent e) {
        signal.scrollDelta.dy < 0
            ? _textScalerCubit.zoomIn()
            : _textScalerCubit.zoomOut();
      });
    }
  }
}
