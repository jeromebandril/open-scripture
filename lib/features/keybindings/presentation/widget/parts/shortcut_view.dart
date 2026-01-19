import 'package:flutter/material.dart';

import '../../../../../core/utils/keyboard_tokenizer.dart';
import 'keycap.dart';

class ShortcutView extends StatelessWidget {
  final ShortcutActivator? activator;
  final String unassignedText;

  const ShortcutView({
    super.key,
    required this.activator,
    this.unassignedText = 'Unassigned',
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
      spacing: 6,
      runSpacing: 6,
      children: tokens.map((t) => Keycap(t)).toList(),
    );
  }
}
