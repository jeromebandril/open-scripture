import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
    this.icon, {
    super.key,
    required this.onTap,
    this.tooltipMessage,
  });

  final IconData icon;
  final Function() onTap;
  final String? tooltipMessage;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Tooltip(
        message: tooltipMessage ?? '',
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          mouseCursor: SystemMouseCursors.click,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 32, maxHeight: 32),
            child: Center(
              child: MouseRegion(
                child: Icon(
                  icon,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
