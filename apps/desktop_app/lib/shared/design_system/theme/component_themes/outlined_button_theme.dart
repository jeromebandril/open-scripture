import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

abstract final class AppOutlinedButtonTheme {
  AppOutlinedButtonTheme._();

  static OutlinedButtonThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color fgColor = isLight ? AppColors.primary : AppColors.primaryDark;
    final Color borderColor =
        isLight ? AppColors.outline : AppColors.outlineDark;
    final Color disabledFg = isLight ? AppColors.grey400 : AppColors.grey600;
    final Color disabledBorder =
        isLight ? AppColors.grey200 : AppColors.grey700;

    return OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return disabledFg;
          return fgColor;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.withOpacity(fgColor, 0.10);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.withOpacity(fgColor, 0.05);
          }
          return AppColors.transparent;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: disabledBorder);
          }
          if (states.contains(WidgetState.focused) ||
              states.contains(WidgetState.pressed)) {
            return BorderSide(color: fgColor, width: 1.5);
          }
          return BorderSide(color: borderColor);
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
