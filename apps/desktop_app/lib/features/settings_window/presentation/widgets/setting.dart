import 'package:flutter/material.dart';
import '../../../../shared/design_system/tokens/tokens.dart';

class Setting extends StatelessWidget {
  const Setting({
    required this.label,
    required this.description,
    required this.child,
    this.settingWidth = 200,
    this.breakpoint = 450,
    super.key,
  });

  final String label;
  final String description;
  final Widget child;
  final double settingWidth;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < breakpoint;

        final labelWidget = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: isCompact ? 0 : AppSpacing.xs,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              description,
              style: const TextStyle(fontWeight: FontWeight.w300),
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
