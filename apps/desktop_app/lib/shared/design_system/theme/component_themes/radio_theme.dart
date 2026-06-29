import 'package:flutter/material.dart';

import '../../tokens/colors.dart';

abstract final class AppRadioTheme {
  AppRadioTheme._();

  static RadioThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color activeColor =
        isLight ? AppColors.primary : AppColors.primaryDark;
    final Color borderColor =
        isLight ? AppColors.outline : AppColors.outlineDark;
    final Color disabledColor = isLight ? AppColors.grey300 : AppColors.grey700;

    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return disabledColor;
        if (states.contains(WidgetState.selected)) return activeColor;
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return activeColor;
        }
        return borderColor;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColors.withOpacity(activeColor, 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return AppColors.withOpacity(activeColor, 0.06);
        }
        return AppColors.transparent;
      }),
      splashRadius: 18,
      mouseCursor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.forbidden;
        }
        return SystemMouseCursors.click;
      }),
    );
  }
}
