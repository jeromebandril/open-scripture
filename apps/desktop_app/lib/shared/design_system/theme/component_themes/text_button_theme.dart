import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

abstract final class AppTextButtonTheme {
  AppTextButtonTheme._();

  static TextButtonThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;
    final Color fg = isLight ? AppColors.primary : AppColors.primaryDark;
    final Color disabledFg = isLight ? AppColors.grey400 : AppColors.grey600;

    return TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return disabledFg;
          return fg;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.withOpacity(fg, 0.10);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.withOpacity(fg, 0.05);
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
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
        textStyle: WidgetStateProperty.all(AppTypography.labelLg),
        minimumSize: WidgetStateProperty.all(const Size(40, 36)),
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
