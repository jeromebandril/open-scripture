import 'package:flutter/material.dart';

import '../../../../shared/design_system/design_system.dart';
import '../models/settings_route.dart';

class SettingSidebarNav extends StatelessWidget {
  final double width;
  final String selectedRoute;
  final ValueChanged<String> onSelectRoute;

  const SettingSidebarNav({
    super.key,
    required this.width,
    required this.selectedRoute,
    required this.onSelectRoute,
  });

  @override
  Widget build(BuildContext context) {
    final navigationMenu = sidebarNavigation;
    final isCompact = MediaQuery.of(context).size.width < AppBreakpoints.small;
    final theme = Theme.of(context);

    return Flexible(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadius.lg),
              bottomLeft: Radius.circular(AppRadius.lg)),
          color: theme.colorScheme.surfaceContainerHigh,
        ),
        padding: EdgeInsets.symmetric(
          vertical: isCompact ? 0 : AppSpacing.lg,
          horizontal: 12,
        ),
        child: ListView(
          children: [
            if (!isCompact)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Settings',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            ...navigationMenu.entries.expand((entry) {
              final group = entry.key;
              final pages = entry.value;

              // If a platform has hidden all pages in this group, don't show the header at all
              if (pages.isEmpty) return const <Widget>[];

              return [
                // Group Header Text

                if (!isCompact)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, top: 12, bottom: 6),
                    child: Text(
                      group.title,
                      style: theme.textTheme.labelSmall,
                    ),
                  ),

                if (isCompact) const SizedBox(height: AppSpacing.xs),

                // Group Section Box
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: Column(
                    children: [
                      for (final page in pages)
                        _NavigationButton(
                          page.name,
                          icon: page.icon,
                          route: page.route,
                          isSelected: page.route == selectedRoute,
                          isCompact: isCompact,
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
  static const height = 40.0;

  final String text;
  final IconData? icon;
  final String route;
  final bool isSelected;
  final Function()? onTap;
  final bool isCompact;

  const _NavigationButton(
    this.text, {
    this.icon,
    required this.route,
    this.isSelected = false,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      color:
          isSelected ? theme.colorScheme.primaryContainer : Colors.transparent,
      child: Tooltip(
        message: isCompact ? text : '',
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            alignment: Alignment.centerLeft,
            height: height,
            child: Row(
              spacing: AppSpacing.lg,
              mainAxisAlignment: isCompact
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                if (!isCompact)
                  Expanded(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
