import 'package:flutter/material.dart';

import '../../tokens/colors.dart';

abstract final class AppProgressIndicatorTheme {
  AppProgressIndicatorTheme._();

  static ProgressIndicatorThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    return ProgressIndicatorThemeData(
      color: isLight ? AppColors.primary : AppColors.primaryDark,
      linearTrackColor: isLight
          ? AppColors.surfaceContainerHigh
          : AppColors.surfaceContainerHighDark,
      linearMinHeight: 4,
      circularTrackColor: isLight
          ? AppColors.surfaceContainerHigh
          : AppColors.surfaceContainerHighDark,
    );
  }
}
