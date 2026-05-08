import 'package:flutter/material.dart';

import '../theme/tokens.dart';

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
              Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
