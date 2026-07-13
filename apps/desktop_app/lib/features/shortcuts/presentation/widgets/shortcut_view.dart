import 'package:flutter/material.dart';

import '../../../../shared/utils/keyboard_tokenizer.dart';
import 'keycap.dart';

class ShortcutView extends StatelessWidget {
  final ShortcutActivator? activator;
  final String unassignedText;
  final Color? fillColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;

  const ShortcutView({
    super.key,
    required this.activator,
    this.unassignedText = 'Unassigned',
    this.fillColor,
    this.textColor,
    this.borderColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = shortcutTokens(activator);

    if (tokens.isEmpty) {
      return Text(
        unassignedText,
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 2,
      runSpacing: 6,
      children: tokens
          .expand((t) => [
                Keycap(
                  t,
                  fillColor: fillColor,
                  textColor: textColor,
                  borderColor: borderColor,
                  fontSize: fontSize,
                ),
                Text('+', style: TextStyle(fontSize: fontSize))
              ])
          .toList()
        ..removeLast(),
    );
  }
}
