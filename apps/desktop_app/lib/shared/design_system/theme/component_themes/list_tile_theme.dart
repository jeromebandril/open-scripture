import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

abstract final class AppListTileTheme {
  AppListTileTheme._();

  static ListTileThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    return ListTileThemeData(
      tileColor: AppColors.transparent,
      selectedTileColor:
          isLight ? AppColors.primaryContainer : AppColors.primaryContainerDark,
      selectedColor: isLight
          ? AppColors.onPrimaryContainer
          : AppColors.onPrimaryContainerDark,
      textColor: isLight ? AppColors.onSurface : AppColors.onSurfaceDark,
      iconColor:
          isLight ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariantDark,
      titleTextStyle: AppTypography.bodyMd.copyWith(
        color: isLight ? AppColors.onSurface : AppColors.onSurfaceDark,
      ),
      subtitleTextStyle: AppTypography.bodySm.copyWith(
        color: isLight
            ? AppColors.onSurfaceVariant
            : AppColors.onSurfaceVariantDark,
      ),
      leadingAndTrailingTextStyle: AppTypography.labelSm.copyWith(
        color: isLight
            ? AppColors.onSurfaceVariant
            : AppColors.onSurfaceVariantDark,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
      dense: false,
      horizontalTitleGap: AppSpacing.md,
      minVerticalPadding: AppSpacing.sm,
      enableFeedback: true,
      mouseCursor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.forbidden;
        }
        return SystemMouseCursors.click;
      }),
    );
  }
}
