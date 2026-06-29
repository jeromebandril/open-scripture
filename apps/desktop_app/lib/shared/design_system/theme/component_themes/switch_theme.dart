import 'package:flutter/material.dart';

import '../../tokens/colors.dart';

abstract final class AppSwitchTheme {
  AppSwitchTheme._();

  static SwitchThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color activeTrack =
        isLight ? AppColors.primary : AppColors.primaryDark;
    final Color activeThumb =
        isLight ? AppColors.onPrimary : AppColors.onPrimaryDark;
    final Color inactiveTrack = isLight
        ? AppColors.surfaceContainerHighest
        : AppColors.surfaceContainerHighestDark;
    final Color inactiveThumb =
        isLight ? AppColors.outline : AppColors.outlineDark;
    final Color disabledTrack = isLight ? AppColors.grey200 : AppColors.grey800;
    final Color disabledThumb = isLight ? AppColors.grey400 : AppColors.grey600;

    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return disabledThumb;
        if (states.contains(WidgetState.selected)) return activeThumb;
        return inactiveThumb;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return disabledTrack;
        if (states.contains(WidgetState.selected)) return activeTrack;
        return inactiveTrack;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.transparent;
        if (states.contains(WidgetState.disabled)) return AppColors.transparent;
        return isLight ? AppColors.outline : AppColors.outlineDark;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        final Color base =
            states.contains(WidgetState.selected) ? activeTrack : inactiveThumb;
        if (states.contains(WidgetState.pressed)) {
          return AppColors.withOpacity(base, 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return AppColors.withOpacity(base, 0.06);
        }
        return AppColors.transparent;
      }),
      splashRadius: 20,
      mouseCursor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.forbidden;
        }
        return SystemMouseCursors.click;
      }),
    );
  }
}
