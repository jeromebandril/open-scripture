import 'package:flutter/material.dart';

import '../../../../../shared/design_system/design_system.dart';
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
    final navigationMenu = sidebarNavigation;

    return Flexible(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.lg),
              bottomLeft: Radius.circular(AppRadius.lg)),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
        padding:
            const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: 12),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 18),
            ...navigationMenu.entries.expand((entry) {
              final group = entry.key;
              final pages = entry.value;

              // If a platform has hidden all pages in this group, don't show the header at all
              if (pages.isEmpty) return const <Widget>[];

              return [
                // Group Header Text
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12, bottom: 6),
                  child: Text(
                    group.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                // Group Section Box
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: Column(
                    children: [
                      for (final page in pages)
                        _NavigationButton(
                          page.name,
                          icon: page.icon,
                          route: page.route,
                          isSelected: page.route == selectedRoute,
                          onTap: () => onSelectRoute(page.route),
                        )
                    ],
                  ),
                ),
              ];
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
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : Colors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        borderRadius: BorderRadius.circular(AppRadius.sm),
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
              const SizedBox(width: 16),
              Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }
}
