import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

abstract final class AppTabBarTheme {
  AppTabBarTheme._();

  static TabBarThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color selectedFg =
        isLight ? AppColors.primary : AppColors.primaryDark;
    final Color unselectedFg =
        isLight ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariantDark;
    final Color indicator = isLight ? AppColors.primary : AppColors.primaryDark;
    final Color divider =
        isLight ? AppColors.outlineVariant : AppColors.outlineVariantDark;

    return TabBarThemeData(
      labelColor: selectedFg,
      unselectedLabelColor: unselectedFg,
      labelStyle: AppTypography.labelMd,
      unselectedLabelStyle: AppTypography.labelMd,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: indicator, width: 2),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: divider,
      dividerHeight: 1,
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColors.withOpacity(selectedFg, 0.10);
        }
        if (states.contains(WidgetState.hovered)) {
          return AppColors.withOpacity(selectedFg, 0.05);
        }
        return AppColors.transparent;
      }),
      mouseCursor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.none;
        }
        return SystemMouseCursors.click;
      }),
      splashFactory: NoSplash.splashFactory,
    );
  }
}
