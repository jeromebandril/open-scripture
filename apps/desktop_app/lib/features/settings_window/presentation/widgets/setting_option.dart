import 'package:flutter/material.dart';
import '../../../../shared/design_system/design_system.dart';

class SettingOption extends StatelessWidget {
  const SettingOption({
    required this.label,
    this.description,
    required this.child,
    this.settingWidth = 200,
    this.breakpoint = 450,
    super.key,
  });

  final String label;
  final String? description;
  final Widget child;
  final double settingWidth;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < breakpoint;

        final labelWidget = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: isCompact ? AppSpacing.xs : AppSpacing.sm,
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge,
            ),
            if (description != null)
              Text(
                description!,
                style: theme.textTheme.bodySmall,
              ),
          ],
        );

        final settingWidget = SizedBox(
          width: isCompact ? double.infinity : settingWidth,
          child: Align(
            alignment: Alignment.centerRight,
            child: child,
          ),
        );

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              labelWidget,
              settingWidget,
            ],
          );
        }

        return Row(
          spacing: AppSpacing.md,
          children: [
            Expanded(child: labelWidget),
            settingWidget,
          ],
        );
      },
    );
  }
}
