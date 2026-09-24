import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class QuickSlidesImport extends StatelessWidget {
  const QuickSlidesImport({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
      ),
      child: Row(
        children: [
          TextButton.icon(
              onPressed: () {},
              icon: Icon(LucideIcons.import),
              label: Text('Quick Import')),
        ],
      ),
    );
  }
}
