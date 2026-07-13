import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/typography.dart';

abstract final class AppChipTheme {
  AppChipTheme._();

  static ChipThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color bg = isLight
        ? AppColors.surfaceContainerHigh
        : AppColors.surfaceContainerHighDark;
    final Color fg = isLight ? AppColors.onSurface : AppColors.onSurfaceDark;
    final Color selectedBg =
        isLight ? AppColors.primaryContainer : AppColors.primaryContainerDark;
    final Color selectedFg = isLight
        ? AppColors.onPrimaryContainer
        : AppColors.onPrimaryContainerDark;
    final Color border =
        isLight ? AppColors.outlineVariant : AppColors.outlineVariantDark;
    final Color disabledBg = isLight ? AppColors.grey100 : AppColors.grey800;
    final Color disabledFg = isLight ? AppColors.grey400 : AppColors.grey600;

    return ChipThemeData(
      backgroundColor: bg,
      selectedColor: selectedBg,
      disabledColor: disabledBg,
      deleteIconColor:
          isLight ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariantDark,
      labelStyle: AppTypography.labelMd.copyWith(color: fg),
      secondaryLabelStyle: AppTypography.labelMd.copyWith(color: selectedFg),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.chip,
        side: BorderSide(color: border),
      ),
      side: BorderSide(color: border),
      elevation: 0,
      pressElevation: 0,
      shadowColor: AppColors.transparent,
      showCheckmark: true,
      checkmarkColor: selectedFg,
      // Disabled
      iconTheme: IconThemeData(
        color: disabledFg,
        size: 18,
      ),
    );
  }
}
