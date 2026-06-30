import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';

abstract final class AppCardTheme {
  AppCardTheme._();

  static CardThemeData build({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    return CardThemeData(
      // Cards sit on top of the scaffold background, so use the lowest surface.
      color: isLight
          ? AppColors.surfaceContainerLowest
          : AppColors.surfaceContainerLowestDark,
      shadowColor: AppColors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: BorderSide(
          color:
              isLight ? AppColors.outlineVariant : AppColors.outlineVariantDark,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
    );
  }
}
