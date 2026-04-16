import 'package:flutter/material.dart';
import 'package:open_scripture/shared/theme/tokens.dart';

class Setting extends StatelessWidget {
  const Setting({
    required this.label,
    required this.description,
    required this.child,
    this.settingWidth = 200,
    super.key,
  });

  final String label;
  final String description;
  final Widget child;
  final double settingWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.md,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xs,
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
              Text(description, style: TextStyle(fontWeight: FontWeight.w300)),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          width: settingWidth,
          child: child,
        )
      ],
    );
  }
}
