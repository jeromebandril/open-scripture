import 'package:flutter/material.dart';

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
      spacing: 16,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
