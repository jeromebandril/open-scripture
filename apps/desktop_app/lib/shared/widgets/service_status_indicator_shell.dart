import 'package:flutter/material.dart';
import '../design_system/design_system.dart';

class ServiceStatusIndicatorShell extends StatelessWidget {
  const ServiceStatusIndicatorShell({
    super.key,
    required this.label,
    required this.icon,
    this.onLabelPressed,
    this.labelTooltipMessage,
    this.onIconPressed,
    this.iconTooltipMessage,
  });

  final Widget label;
  final VoidCallback? onLabelPressed;
  final String? labelTooltipMessage;
  //
  final IconData icon;
  final VoidCallback? onIconPressed;
  final String? iconTooltipMessage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: onLabelPressed == null ? null : SystemMouseCursors.click,
      onTap: onLabelPressed,
      child: Container(
        height: 28,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Tooltip(message: labelTooltipMessage ?? '', child: label),
            const SizedBox(width: AppSpacing.xs),
            IconButton(
              tooltip: iconTooltipMessage,
              onPressed: onIconPressed,
              icon: Icon(icon),
              visualDensity: VisualDensity.compact,
            )
          ],
        ),
      ),
    );
  }
}
