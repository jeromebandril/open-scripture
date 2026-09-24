import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../../features/settings_window/presentation/widgets/parts/reset_button.dart';

import '../../../../utils/colors_util.dart';
import 'color_circle.dart';

class AppInputColor extends StatefulWidget {
  const AppInputColor({
    super.key,
    this.color = Colors.red,
    this.onColorChanged,
    this.isDisabled = false,
    this.showReset = false,
    this.onReset,
  });

  final Color color;
  final Function(Color)? onColorChanged;
  final bool isDisabled;

  final bool showReset;
  final Function()? onReset;

  @override
  State<AppInputColor> createState() => _AppInputColorState();
}

class _AppInputColorState extends State<AppInputColor> {
  OverlayEntry? entry;
  final LayerLink layerLink = LayerLink();
  Color? selectedColor;

  void _showOverlay() {
    final screen = MediaQuery.of(context).size;
    final overlay = Overlay.of(context, rootOverlay: true);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    entry = OverlayEntry(
        // Capture the app’s inherited theme widgets from the button’s context.
        builder: (ctx) => InheritedTheme.captureAll(
              context,
              Stack(
                children: [
                  // Full-screen barrier for outside taps
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _hideOverlay();
                      },
                    ),
                  ),
                  CompositedTransformFollower(
                    link: layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(-300, size.height),
                    child: _buildOverlay(screen),
                  ),
                ],
              ),
            ));
    overlay.insert(entry!);
  }

  Widget _buildOverlay(Size screenSize) {
    return Card(
      elevation: 10,
      child: Container(
        width: 300,
        height: 280,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ColorPicker(
          pickerColor: widget.color,
          onColorChanged: (color) => selectedColor = color,
          hexInputBar: true,
          colorPickerWidth: 300,
          labelTypes: [],
          portraitOnly: true,
          enableAlpha: false,
          pickerAreaHeightPercent: 0.5,
          pickerAreaBorderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _hideOverlay() {
    entry?.remove();
    if (selectedColor != null && widget.onColorChanged != null) {
      widget.onColorChanged!.call(selectedColor!);
    }
    entry = null;
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 8,
      children: [
        if (widget.onReset != null && widget.showReset)
          ResetButton(
            onPress: () => widget.onReset?.call(),
          ),
        Text('#${ColorsUtil.colorToHex(widget.color)}'),
        CompositedTransformTarget(
          link: layerLink,
          child: GestureDetector(
            onTap: () {
              if (widget.isDisabled) return;
              if (entry == null) {
                _showOverlay();
              } else {
                _hideOverlay();
              }
            },
            child: ColorCircle(
                size: 24,
                isDisabled: widget.isDisabled,
                color: widget.isDisabled
                    ? Theme.of(context).colorScheme.onSurface.withAlpha(97)
                    : widget.color),
          ),
        )
      ],
    );
  }
}
