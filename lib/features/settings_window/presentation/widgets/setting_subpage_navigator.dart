import 'package:flutter/material.dart';

class SettingSubpageNavigatorData {
  final Function() onSelect;
  final Icon icon;
  final String title;

  SettingSubpageNavigatorData({
    required this.onSelect,
    required this.icon,
    required this.title,
  });
}

class SettingSubpageNavigator extends StatelessWidget {
  const SettingSubpageNavigator({super.key, required this.data});

  final List<SettingSubpageNavigatorData> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      height: 40,
      child: Row(
        children: [
          for (final d in data)
            TextButton(
              onPressed: d.onSelect,
              child: Row(
                spacing: 8,
                children: [
                  d.icon,
                  Text(d.title),
                ],
              ),
            )
        ],
      ),
    );
  }
}
