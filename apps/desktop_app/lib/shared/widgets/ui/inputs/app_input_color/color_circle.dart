import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../../app/models/gradient_preset.dart';

class ColorCircle extends StatelessWidget {
  const ColorCircle({
    super.key,
    this.color,
    this.gradient,
    this.gradientPreset,
    this.size = 24,
    this.isDisabled = false,
  });
  // : assert(
  //         (color == null) != (gradient == null || gradientPreset == null),
  //         'Provide exactly one of color, gradient, or gradientPreset.',
  //       );

  final double size;
  final Color? color;
  final Gradient? gradient;
  final GradientPreset? gradientPreset;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipOval(
              child: _buildBackground(),
            ),
          ),
          if (isDisabled)
            Center(
              child: CustomPaint(
                size: Size(size, size),
                painter: const _DiagonalLinePainter(
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    if (color != null) {
      return ColoredBox(color: color!);
    }

    if (gradient != null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
      );
    }

    return CustomPaint(
      painter: GradientPresetPainter(gradientPreset!),
    );
  }
}

class GradientPresetPainter extends CustomPainter {
  const GradientPresetPainter(this.preset);

  final GradientPreset preset;

  @override
  void paint(Canvas canvas, Size size) {
    switch (preset.type) {
      case GradientType.radial:
        _paintRadial(canvas, size);
      case GradientType.complex:
        _paintComplex(canvas, size);
    }
  }

  void _paintRadial(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = preset.gradient.createShader(
        Offset.zero & size,
      );

    canvas.drawRect(
      Offset.zero & size,
      paint,
    );
  }

  void _paintComplex(Canvas canvas, Size size) {
    final colors = preset.colors;
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(size.width, size.height),
          [
            Color.alphaBlend(
              colors[1].withValues(alpha: 0.12),
              colors[2],
            ),
            colors[2],
          ],
          const [0.0, 1.0],
        ),
    );

    _drawGlow(
      canvas,
      size,
      center: Offset(
        size.width * 0.02,
        size.height * -0.02,
      ),
      radius: size.width * 0.9,
      color: colors[0],
      opacity: 0.85,
    );

    _drawGlow(
      canvas,
      size,
      center: Offset(
        size.width * 0.96,
        size.height * 0.14,
      ),
      radius: size.width * 0.68,
      color: colors[1],
      opacity: 0.55,
    );

    _drawGlow(
      canvas,
      size,
      center: Offset(
        size.width * 0.12,
        size.height * 1.05,
      ),
      radius: size.width * 0.72,
      color: colors[1],
      opacity: 0.20,
    );

    _drawVignette(canvas, size);
  }

  void _drawGlow(
    Canvas canvas,
    Size size, {
    required Offset center,
    required double radius,
    required Color color,
    required double opacity,
  }) {
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          color.withValues(alpha: opacity),
          color.withValues(alpha: opacity * 0.42),
          color.withValues(alpha: opacity * 0.08),
          Colors.transparent,
        ],
        const [
          0.0,
          0.28,
          0.58,
          1.0,
        ],
      );

    canvas.drawRect(
      Offset.zero & size,
      paint,
    );
  }

  void _drawVignette(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(
          size.width * 0.5,
          size.height * 0.5,
        ),
        size.longestSide * 0.8,
        [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.10),
          Colors.black.withValues(alpha: 0.30),
        ],
        const [
          0.45,
          0.78,
          1.0,
        ],
      );

    canvas.drawRect(
      Offset.zero & size,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant GradientPresetPainter oldDelegate) {
    return oldDelegate.preset != preset;
  }
}

class _DiagonalLinePainter extends CustomPainter {
  const _DiagonalLinePainter({
    this.color = Colors.red,
  })  : strokeWidth = 2,
        strokeCap = StrokeCap.butt,
        angleRadians = math.pi / 4;

  final double strokeWidth;
  final Color color;
  final double angleRadians;
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2;
    final c = Offset(r, r);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap;

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angleRadians);
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
