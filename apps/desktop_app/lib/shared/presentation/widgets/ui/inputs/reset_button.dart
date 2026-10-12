import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key, this.onPress});

  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPress, icon: const Icon(LucideIcons.rotateCcw));
  }
}
