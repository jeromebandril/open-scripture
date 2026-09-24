import 'dart:math' as math;

import 'package:flutter/material.dart';

class ColorCircle extends StatelessWidget {
  const ColorCircle({
    super.key,
    this.color,
    this.gradient,
    this.size = 24,
    this.isDisabled = false,
  }) : assert(
          (color == null) != (gradient == null),
          'Provide either a color or a gradient.',
        );

  final double size;
  final Color? color;
  final Gradient? gradient;
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
              gradient: gradient,
            ),
          ),
          if (isDisabled)
            Center(
              child: CustomPaint(
                size: Size(size, size),
                painter: const _DiagonalLinePainter(color: Colors.red),
              ),
            ),
        ],
      ),
    );
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
