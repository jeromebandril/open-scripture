import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/typography.dart';

abstract final class AppTextTheme {
  AppTextTheme._();

  static TextTheme build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color primary =
        isLight ? AppColors.onSurface : AppColors.onSurfaceDark;
    final Color secondary =
        isLight ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariantDark;

    return TextTheme(
      displayLarge: AppTypography.display2xl.copyWith(color: primary),
      displayMedium: AppTypography.displayXl.copyWith(color: primary),
      displaySmall: AppTypography.displayLg.copyWith(color: primary),
      headlineLarge: AppTypography.displayMd.copyWith(color: primary),
      headlineMedium: AppTypography.displaySm.copyWith(color: primary),
      headlineSmall: AppTypography.headingXl.copyWith(color: primary),
      titleLarge: AppTypography.headingLg.copyWith(color: primary),
      titleMedium: AppTypography.headingMd.copyWith(color: primary),
      titleSmall: AppTypography.headingSm.copyWith(color: primary),
      bodyLarge: AppTypography.bodyLg.copyWith(color: primary),
      bodyMedium: AppTypography.bodyMd.copyWith(color: primary),
      bodySmall: AppTypography.bodySm.copyWith(color: secondary),
      labelLarge: AppTypography.labelLg.copyWith(color: primary),
      labelMedium: AppTypography.labelMd.copyWith(color: primary),
      labelSmall: AppTypography.labelSm.copyWith(color: secondary),
    );
  }
}
