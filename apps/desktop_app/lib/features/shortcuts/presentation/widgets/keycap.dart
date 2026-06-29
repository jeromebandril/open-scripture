import 'package:flutter/material.dart';
import 'package:open_scripture/shared/design_system/design_system.dart';

class Keycap extends StatelessWidget {
  final String text;
  final Color? fillColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;

  const Keycap(
    this.text, {
    super.key,
    this.fillColor,
    this.textColor,
    this.borderColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: fillColor ?? cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(color: borderColor ?? cs.outlineVariant),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium!.copyWith(
          fontFamily: "IBM Plex Mono",
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
