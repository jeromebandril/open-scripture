import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/parts/reset_button.dart';

import '../../../../core/utils/colors_util.dart';

class SettingInputColor extends StatefulWidget {
  const SettingInputColor({
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
  State<SettingInputColor> createState() => _SettingInputColorState();
}

class _SettingInputColorState extends State<SettingInputColor> {
  OverlayEntry? entry;
  final LayerLink layerLink = LayerLink();
  Color? selectedColor;

  void _showOverlay() {
    final screen = MediaQuery.of(context).size;
    final overlay = Overlay.of(context, rootOverlay: true);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    // final offset = renderBox.localToGlobal(Offset.zero);

    entry = OverlayEntry(
        // Capture *the app’s* inherited theme widgets from the button’s context.
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
        height: 300,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ColorPicker(
          pickerColor: widget.color,
          onColorChanged: (color) => selectedColor = color,
          colorPickerWidth: 300,
          portraitOnly: true,
          enableAlpha: false,
          pickerAreaHeightPercent: 0.5,
          pickerAreaBorderRadius: BorderRadius.circular(8),
        ),

        // ColorPicker(
        //   pickerColor: widget.color,
        //   onColorChanged: (color) {},
        //   paletteType: PaletteType.hsl,
        //   enableAlpha: true,
        //   displayThumbColor: true,
        //   pickerAreaHeightPercent: 1,
        // ),
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
            child: _ColorCircle(
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

class _ColorCircle extends StatelessWidget {
  const _ColorCircle({
    required this.color,
    this.size = 24,
    this.isDisabled = false,
  });

  final double size;
  final Color color;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          if (isDisabled)
            Center(
              child: CustomPaint(
                size: Size(size, size),
                painter: const _DiagonalLinePainter(
                  strokeWidth: 2,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DiagonalLinePainter extends CustomPainter {
  const _DiagonalLinePainter({
    this.strokeWidth = 2,
    this.color = Colors.red,
    this.angleRadians = math.pi / 4, // 45 degrees: top-left -> bottom-right
    this.strokeCap = StrokeCap.butt, // use butt for exact diameter length
  });

  final double strokeWidth;
  final Color color;
  final double angleRadians;
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2.0;
    final c = Offset(r, r);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap;

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angleRadians);

    // Draw a line exactly equal to the circle diameter (2r), centered.
    canvas.drawLine(Offset(-r, 0), Offset(r, 0), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DiagonalLinePainter oldDelegate) {
    return strokeWidth != oldDelegate.strokeWidth ||
        color != oldDelegate.color ||
        angleRadians != oldDelegate.angleRadians ||
        strokeCap != oldDelegate.strokeCap;
  }
}
