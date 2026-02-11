import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final bool glowing;
  final Color? overrideGlowingColor;
  final Color? overrideColor;
  final String? tooltipMessage;

  const Dot({
    super.key,
    this.glowing = false,
    this.overrideGlowingColor,
    this.overrideColor,
    this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    double size = glowing ? 12 : 8;

    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: glowing
            ? overrideGlowingColor ??
                Theme.of(context).colorScheme.onSurfaceVariant
            : overrideColor ??
                Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
