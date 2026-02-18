import 'package:flutter/material.dart';

class Keycap extends StatelessWidget {
  final String text;

  const Keycap(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium!.copyWith(
          fontFamily: "IBM Plex Mono",
        ),
      ),
    );
  }
}
