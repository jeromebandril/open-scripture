import 'package:flutter/material.dart';

class SettingSubpageNavigatorData {
  final int id;
  final Function(int) onSelect;
  final Icon icon;
  final String title;

  SettingSubpageNavigatorData({
    required this.id,
    required this.onSelect,
    required this.icon,
    required this.title,
  });
}

class SettingSubpageNavigator extends StatelessWidget {
  const SettingSubpageNavigator(
      {super.key, required this.data, this.selectedId});

  final List<SettingSubpageNavigatorData> data;
  final int? selectedId;

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
            _NavBtn(
              navData: d,
              isActive: d.id == selectedId,
            )
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  const _NavBtn({required this.navData, this.isActive = false});

  final SettingSubpageNavigatorData navData;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;

    final bgColor = isActive ? color.withAlpha(60) : Colors.transparent;

    return Material(
      borderRadius: BorderRadius.circular(4),
      color: bgColor,
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: color.withAlpha(30),
        onTap: () => navData.onSelect.call(navData.id),
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            spacing: 8,
            children: [
              Icon(
                navData.icon.icon,
                size: 16,
                color: color,
              ),
              Text(
                navData.title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
