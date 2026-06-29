import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';

abstract final class AppIconButtonTheme {
  AppIconButtonTheme._();

  static IconButtonThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;
    final Color fg =
        isLight ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariantDark;
    final Color disabledFg = isLight ? AppColors.grey300 : AppColors.grey600;

    return IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return disabledFg;
          if (states.contains(WidgetState.selected)) {
            return isLight ? AppColors.primary : AppColors.primaryDark;
          }
          return fg;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return isLight
                ? AppColors.primaryContainer
                : AppColors.primaryContainerDark;
          }
          return AppColors.transparent;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.blackOverlay(isLight ? 0.10 : 0.14);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.blackOverlay(isLight ? 0.05 : 0.08);
          }
          return AppColors.transparent;
        }),
        elevation: WidgetStateProperty.all(0),
        shadowColor: WidgetStateProperty.all(AppColors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        ),
        minimumSize: WidgetStateProperty.all(const Size(36, 36)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        mouseCursor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return SystemMouseCursors.forbidden;
          }
          return SystemMouseCursors.click;
        }),
      ),
    );
  }
}
