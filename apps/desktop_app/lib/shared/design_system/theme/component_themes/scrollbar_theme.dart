import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';

/// Scrollbar — critical on desktop where scroll wheels are the primary input.
abstract final class AppScrollbarTheme {
  AppScrollbarTheme._();

  static ScrollbarThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color thumbIdle = isLight
        ? AppColors.withOpacity(AppColors.outline, 0.5)
        : AppColors.withOpacity(AppColors.outlineDark, 0.5);
    final Color thumbHover =
        isLight ? AppColors.outline : AppColors.outlineDark;
    final Color track = AppColors.transparent;

    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.dragged) ||
            states.contains(WidgetState.hovered)) {
          return thumbHover;
        }
        return thumbIdle;
      }),
      trackColor: WidgetStateProperty.all(track),
      trackBorderColor: WidgetStateProperty.all(AppColors.transparent),
      thickness: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.dragged)) {
          return 8.0;
        }
        return 4.0;
      }),
      radius: AppRadius.radiusFull.topLeft,
      interactive: true,
      // Show scrollbar on desktop — don't wait for scroll to reveal it.
      thumbVisibility: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.dragged);
      }),
      trackVisibility: WidgetStateProperty.all(false),
      crossAxisMargin: 2,
      mainAxisMargin: 2,
    );
  }
}
