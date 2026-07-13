import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

abstract final class AppTooltipTheme {
  AppTooltipTheme._();

  static TooltipThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    // Tooltips intentionally invert the surface — dark tooltip on light,
    // light tooltip on dark — for maximum contrast.
    final Color bg =
        isLight ? AppColors.inverseSurface : AppColors.inverseSurfaceDark;
    final Color fg =
        isLight ? AppColors.onInverseSurface : AppColors.onInverseSurfaceDark;

    return TooltipThemeData(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.tooltip,
      ),
      textStyle: AppTypography.bodySm.copyWith(color: fg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      waitDuration: const Duration(milliseconds: 500),
      showDuration: const Duration(seconds: 2),
      preferBelow: true,
    );
  }
}
