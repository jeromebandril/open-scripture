import 'package:flutter/material.dart';

import '../../models/settings_route.dart';

class SidebarNavigator extends StatelessWidget {
  final double width;
  final String selectedRoute;
  final ValueChanged<String> onSelectRoute;

  const SidebarNavigator({
    super.key,
    required this.width,
    required this.selectedRoute,
    required this.onSelectRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            //
            // All navigation buttons
            //
            ...settingsRoutes.entries.map((r) {
              final isSelected = r.key == selectedRoute;
              return _NavigationButton(
                r.value.name,
                icon: r.value.icon,
                route: r.key,
                isSelected: isSelected,
                onTap: () => onSelectRoute(r.key),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String route;
  final bool isSelected;
  final Function()? onTap;

  const _NavigationButton(
    this.text, {
    this.icon,
    required this.route,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      color: isSelected
          ? Theme.of(context).colorScheme.surface
          : Colors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          height: 40,
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 16),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
