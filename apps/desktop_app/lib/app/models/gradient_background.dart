import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'gradient_preset.dart';

class GradientBackground extends StatelessWidget {
  final GradientPreset preset;
  final Widget? child;

  const GradientBackground({
    super.key,
    required this.preset,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return switch (preset.type) {
      GradientType.radial => DecoratedBox(
          decoration: BoxDecoration(
            gradient: preset.gradient,
          ),
          child: child,
        ),
      GradientType.complex => CustomPaint(
          painter: _ComplexGradientPainter(preset),
          child: child,
        ),
    };
  }
}

class _ComplexGradientPainter extends CustomPainter {
  final GradientPreset preset;

  _ComplexGradientPainter(this.preset);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = preset.colors;

    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, 0),
          Offset(size.width, size.height),
          [
            Color.lerp(colors[2], colors[1], 0.18)!,
            colors[2],
          ],
          [0.0, 1.0],
        ),
    );

    _drawGlow(
      canvas,
      size,
      center: Offset(
        size.width * 0.05,
        size.height * 0.02,
      ),
      radius: size.width * 0.85,
      color: colors[0],
      opacity: 0.85,
    );

    _drawGlow(
      canvas,
      size,
      center: Offset(
        size.width * 0.92,
        size.height * 0.18,
      ),
      radius: size.width * 0.65,
      color: colors[1],
      opacity: 0.55,
    );

    _drawGlow(
      canvas,
      size,
      center: Offset(
        size.width * 0.18,
        size.height * 1.05,
      ),
      radius: size.width * 0.75,
      color: colors[1],
      opacity: 0.22,
    );

    _drawGlow(
      canvas,
      size,
      center: Offset(
        size.width * 1.05,
        size.height * 0.95,
      ),
      radius: size.width * 0.7,
      color: colors[0],
      opacity: 0.10,
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
    final center = Offset(
      size.width * 0.5,
      size.height * 0.5,
    );

    final radius = size.longestSide * 0.8;

    final paint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
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
  bool shouldRepaint(covariant _ComplexGradientPainter oldDelegate) {
    return oldDelegate.preset != preset;
  }
}
