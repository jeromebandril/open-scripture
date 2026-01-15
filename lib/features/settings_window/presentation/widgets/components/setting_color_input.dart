import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:the_smyrna_bible_v2/core/utils/colors_util.dart';

class SettingColorInput extends StatefulWidget {
  const SettingColorInput({
    super.key,
    this.color = Colors.red,
    this.onColorChanged,
  });

  final Color color;
  final Function(Color)? onColorChanged;

  @override
  State<SettingColorInput> createState() => _SettingColorInputState();
}

class _SettingColorInputState extends State<SettingColorInput> {
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
        Text('#${ColorsUtil.colorToHex(widget.color)}'),
        CompositedTransformTarget(
          link: layerLink,
          child: GestureDetector(
            onTap: () {
              if (entry == null) {
                _showOverlay();
              } else {
                _hideOverlay();
              }
            },
            child: _ColorCircle(color: widget.color),
          ),
        )
      ],
    );
  }
}

class _ColorCircle extends StatelessWidget {
  const _ColorCircle({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
