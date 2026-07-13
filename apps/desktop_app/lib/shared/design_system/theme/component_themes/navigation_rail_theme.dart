import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

/// Navigation rail — primary nav surface for desktop layouts.
abstract final class AppNavigationRailTheme {
  AppNavigationRailTheme._();

  static NavigationRailThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color bg = isLight ? AppColors.surface : AppColors.surfaceDark;
    final Color unselectedFg =
        isLight ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariantDark;
    final Color selectedFg =
        isLight ? AppColors.primary : AppColors.primaryDark;
    final Color indicatorColor =
        isLight ? AppColors.primaryContainer : AppColors.primaryContainerDark;

    return NavigationRailThemeData(
      backgroundColor: bg,
      elevation: 0,

      // Selected indicator pill
      indicatorColor: indicatorColor,
      indicatorShape: const StadiumBorder(),

      // Icons
      selectedIconTheme: IconThemeData(color: selectedFg, size: 20),
      unselectedIconTheme: IconThemeData(color: unselectedFg, size: 20),

      // Labels
      selectedLabelTextStyle: AppTypography.labelMd.copyWith(color: selectedFg),
      unselectedLabelTextStyle:
          AppTypography.labelMd.copyWith(color: unselectedFg),

      labelType: NavigationRailLabelType.all,
      groupAlignment: -1, // top-aligned
      minWidth: 72,
      minExtendedWidth: 200,
      useIndicator: true,
    );
  }
}
