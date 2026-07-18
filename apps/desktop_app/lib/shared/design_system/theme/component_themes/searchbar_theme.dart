import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

abstract final class AppSearchBarTheme {
  AppSearchBarTheme._();

  static SearchBarThemeData buildBar({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color fill = isLight
        ? AppColors.surfaceContainerHigh
        : AppColors.surfaceContainerHighDark;
    final Color fillHovered = isLight
        ? AppColors.surfaceContainer
        : AppColors.surfaceContainerLowDark;
    final Color textColor =
        isLight ? AppColors.onSurface : AppColors.onSurfaceDark;
    final Color hintColor = isLight ? AppColors.grey400 : AppColors.grey600;
    // final Color iconColor =
    //     isLight ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariantDark;
    final Color borderColor =
        isLight ? AppColors.outlineVariant : AppColors.outlineVariantDark;
    final Color primaryColor =
        isLight ? AppColors.primary : AppColors.primaryDark;

    return SearchBarThemeData(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) return fillHovered;
        return fill;
      }),
      shadowColor: WidgetStateProperty.all(AppColors.transparent),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.focused)) return 0;
        return 1;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColors.blackOverlay(0.08);
        }
        return AppColors.transparent;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return BorderSide(color: primaryColor, width: 1.5);
        }
        return BorderSide(color: borderColor);
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: AppRadius.input),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      ),
      textStyle: WidgetStateProperty.all(
        AppTypography.bodyMd.copyWith(color: textColor),
      ),
      hintStyle: WidgetStateProperty.all(
        AppTypography.bodyMd.copyWith(color: hintColor),
      ),
      // iconColor: WidgetStateProperty.resolveWith((states) {
      //   if (states.contains(WidgetState.focused)) return primaryColor;
      //   return iconColor;
      // }),
    );
  }
}
