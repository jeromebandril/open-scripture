import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';

abstract final class AppCheckboxTheme {
  AppCheckboxTheme._();

  static CheckboxThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color activeColor =
        isLight ? AppColors.primary : AppColors.primaryDark;
    final Color checkColor =
        isLight ? AppColors.onPrimary : AppColors.onPrimaryDark;
    final Color borderColor =
        isLight ? AppColors.outline : AppColors.outlineDark;
    final Color disabledColor = isLight ? AppColors.grey300 : AppColors.grey700;

    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return disabledColor;
        if (states.contains(WidgetState.selected)) return activeColor;
        return AppColors.transparent;
      }),
      checkColor: WidgetStateProperty.all(checkColor),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: disabledColor, width: 1.5);
        }
        if (states.contains(WidgetState.selected)) {
          return BorderSide(color: activeColor, width: 1.5);
        }
        if (states.contains(WidgetState.focused) ||
            states.contains(WidgetState.hovered)) {
          return BorderSide(color: activeColor, width: 1.5);
        }
        return BorderSide(color: borderColor, width: 1.5);
      }),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusSm),
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
