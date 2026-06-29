import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

abstract final class AppPopupMenuTheme {
  AppPopupMenuTheme._();

  static PopupMenuThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color bg = isLight
        ? AppColors.surfaceContainerLowest
        : AppColors.surfaceContainerLowestDark;
    final Color fg = isLight ? AppColors.onSurface : AppColors.onSurfaceDark;
    // final Color hoverBg = isLight
    //     ? AppColors.surfaceContainerLow
    //     : AppColors.surfaceContainerLowDark;

    return PopupMenuThemeData(
      color: bg,
      surfaceTintColor: AppColors.transparent,
      shadowColor: AppColors.shadow,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusLg,
        side: BorderSide(
          color:
              isLight ? AppColors.outlineVariant : AppColors.outlineVariantDark,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final style = AppTypography.bodyMd.copyWith(color: fg);
        if (states.contains(WidgetState.disabled)) {
          return style.copyWith(
            color: isLight ? AppColors.grey400 : AppColors.grey600,
          );
        }
        return style;
      }),
      iconColor:
          isLight ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariantDark,
      mouseCursor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.forbidden;
        }
        return SystemMouseCursors.click;
      }),
      menuPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      position: PopupMenuPosition.under,
    );
  }
}
