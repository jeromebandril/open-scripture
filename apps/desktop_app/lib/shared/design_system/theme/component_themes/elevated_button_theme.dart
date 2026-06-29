import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

abstract final class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static ElevatedButtonThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color bg = isLight ? AppColors.primary : AppColors.primaryDark;
    final Color fg = isLight ? AppColors.onPrimary : AppColors.onPrimaryDark;
    final Color disabledBg = isLight ? AppColors.grey200 : AppColors.grey700;
    final Color disabledFg = isLight ? AppColors.grey400 : AppColors.grey500;

    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return disabledBg;
          return bg;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return disabledFg;
          return fg;
        }),
        // Hover/pressed feedback via overlay — keeps a single background value.
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.blackOverlay(0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.blackOverlay(0.06);
          }
          return AppColors.transparent;
        }),
        elevation: WidgetStateProperty.all(0),
        shadowColor: WidgetStateProperty.all(AppColors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppRadius.button),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
        ),
        textStyle: WidgetStateProperty.all(AppTypography.labelMd),
        minimumSize: WidgetStateProperty.all(const Size(64, 40)),
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
