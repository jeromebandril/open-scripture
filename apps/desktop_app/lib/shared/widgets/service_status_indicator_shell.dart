import 'package:flutter/material.dart';
import '../design_system/design_system.dart';

class ServiceStatusIndicatorShell extends StatelessWidget {
  const ServiceStatusIndicatorShell({
    super.key,
    this.onTap,
    this.tooltipMessage,
    required this.text,
    required this.icon,
  });

  final Function()? onTap;
  final String? tooltipMessage;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: onTap,
      child: Tooltip(
        message: tooltipMessage,
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
              Text(text, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: AppSpacing.sm),
              const SizedBox(width: AppSpacing.xs),
              Icon(icon)
            ],
          ),
        ),
      ),
    );
  }
}
