import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

abstract final class AppInputDecorationTheme {
  AppInputDecorationTheme._();

  static InputDecorationTheme build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color fill = isLight
        ? AppColors.surfaceContainerLowest
        : AppColors.surfaceContainerLowestDark;
    final Color fillDisabled = isLight
        ? AppColors.surfaceContainerHigh
        : AppColors.surfaceContainerHighDark;
    final Color border = isLight ? AppColors.outline : AppColors.outlineDark;
    final Color borderDisabled =
        isLight ? AppColors.outlineVariant : AppColors.outlineVariantDark;
    final Color hintColor = isLight ? AppColors.grey400 : AppColors.grey600;
    final Color labelColor =
        isLight ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariantDark;
    final Color errorColor = isLight ? AppColors.error : AppColors.errorDark;
    final Color iconColor =
        isLight ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariantDark;
    final Color primaryColor =
        isLight ? AppColors.primary : AppColors.primaryDark;

    return InputDecorationTheme(
      filled: true,
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return fillDisabled;
        return fill;
      }),
      hintStyle: AppTypography.bodyMd.copyWith(color: hintColor),
      labelStyle: AppTypography.bodyMd.copyWith(color: labelColor),
      floatingLabelStyle: AppTypography.labelSm.copyWith(color: primaryColor),
      errorStyle: AppTypography.bodySm.copyWith(color: errorColor),
      helperStyle: AppTypography.bodySm.copyWith(color: labelColor),
      border: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: errorColor, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(color: borderDisabled),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) return primaryColor;
        return iconColor;
      }),
      suffixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) return primaryColor;
        return iconColor;
      }),
      isDense: true,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }
}
