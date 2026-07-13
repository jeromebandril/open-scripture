import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

abstract final class AppAppBarTheme {
  AppAppBarTheme._();

  static AppBarTheme build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    return AppBarTheme(
      backgroundColor: isLight ? AppColors.surface : AppColors.surfaceDark,
      foregroundColor: isLight ? AppColors.onSurface : AppColors.onSurfaceDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: AppColors.transparent,
      shape: Border(
        bottom: BorderSide(
          color:
              isLight ? AppColors.outlineVariant : AppColors.outlineVariantDark,
        ),
      ),
      iconTheme: IconThemeData(
        color: isLight ? AppColors.onSurface : AppColors.onSurfaceDark,
        size: 20,
      ),
      actionsIconTheme: IconThemeData(
        color: isLight
            ? AppColors.onSurfaceVariant
            : AppColors.onSurfaceVariantDark,
        size: 20,
      ),
      titleTextStyle: AppTypography.headingMd.copyWith(
        color: isLight ? AppColors.onSurface : AppColors.onSurfaceDark,
      ),
      titleSpacing: 16,
      centerTitle: false,
      systemOverlayStyle:
          isLight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
  }
}
