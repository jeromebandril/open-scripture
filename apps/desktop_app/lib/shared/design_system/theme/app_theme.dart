import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/typography.dart';
import 'component_themes/app_bar_theme.dart';
import 'component_themes/card_theme.dart';
import 'component_themes/checkbox_theme.dart';
import 'component_themes/chip_theme.dart';
import 'component_themes/elevated_button_theme.dart';
import 'component_themes/icon_button_theme.dart';
import 'component_themes/input_decoration_theme.dart';
import 'component_themes/list_tile_theme.dart';
import 'component_themes/navigation_rail_theme.dart';
import 'component_themes/outlined_button_theme.dart';
import 'component_themes/popup_menu_theme.dart';
import 'component_themes/progress_indicator_theme.dart';
import 'component_themes/radio_theme.dart';
import 'component_themes/scrollbar_theme.dart';
import 'component_themes/switch_theme.dart';
import 'component_themes/tab_bar_theme.dart';
import 'component_themes/text_button_theme.dart';
import 'component_themes/tooltip_theme.dart';
import 'app_text_theme.dart';

/// Entry point for the design system theme.
///
/// Usage in your app root:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: ThemeMode.system,
/// )
/// ```
abstract final class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;
    final TextTheme textTheme = AppTextTheme.build(brightness: brightness);

    final ColorScheme colorScheme = isLight
        ? ColorScheme.light(
            brightness: brightness,
            primary: AppColors.primary,
            onPrimary: AppColors.onPrimary,
            primaryContainer: AppColors.primaryContainer,
            onPrimaryContainer: AppColors.onPrimaryContainer,
            secondary: AppColors.secondary,
            onSecondary: AppColors.onSecondary,
            tertiary: AppColors.tertiary,
            onTertiary: AppColors.onTertiary,
            surface: AppColors.surface,
            onSurface: AppColors.onSurface,
            surfaceContainerLowest: AppColors.surfaceContainerLowest,
            surfaceContainerLow: AppColors.surfaceContainerLow,
            surfaceContainer: AppColors.surfaceContainer,
            surfaceContainerHigh: AppColors.surfaceContainerHigh,
            surfaceContainerHighest: AppColors.surfaceContainerHighest,
            onSurfaceVariant: AppColors.onSurfaceVariant,
            outline: AppColors.outline,
            outlineVariant: AppColors.outlineVariant,
            error: AppColors.error,
            onError: AppColors.onError,
            errorContainer: AppColors.errorContainer,
            onErrorContainer: AppColors.onErrorContainer,
            inverseSurface: AppColors.inverseSurface,
            onInverseSurface: AppColors.onInverseSurface,
            inversePrimary: AppColors.inversePrimary,
            shadow: AppColors.shadow,
            scrim: AppColors.scrim,
          )
        : ColorScheme.dark(
            brightness: brightness,
            primary: AppColors.primaryDark,
            onPrimary: AppColors.onPrimaryDark,
            primaryContainer: AppColors.primaryContainerDark,
            onPrimaryContainer: AppColors.onPrimaryContainerDark,
            secondary: AppColors.secondaryDark,
            onSecondary: AppColors.onSecondaryDark,
            tertiary: AppColors.tertiaryDark,
            onTertiary: AppColors.onTertiaryDark,
            surface: AppColors.surfaceDark,
            onSurface: AppColors.onSurfaceDark,
            surfaceContainerLowest: AppColors.surfaceContainerLowestDark,
            surfaceContainerLow: AppColors.surfaceContainerLowDark,
            surfaceContainer: AppColors.surfaceContainerDark,
            surfaceContainerHigh: AppColors.surfaceContainerHighDark,
            surfaceContainerHighest: AppColors.surfaceContainerHighestDark,
            onSurfaceVariant: AppColors.onSurfaceVariantDark,
            outline: AppColors.outlineDark,
            outlineVariant: AppColors.outlineVariantDark,
            error: AppColors.errorDark,
            onError: AppColors.onErrorDark,
            errorContainer: AppColors.errorContainerDark,
            onErrorContainer: AppColors.onErrorContainerDark,
            inverseSurface: AppColors.inverseSurfaceDark,
            onInverseSurface: AppColors.onInverseSurfaceDark,
            inversePrimary: AppColors.inversePrimaryDark,
            shadow: AppColors.shadow,
            scrim: AppColors.scrim,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      splashFactory: NoSplash.splashFactory,

      // -----------------------------------------------------------------------
      // Typography
      // -----------------------------------------------------------------------
      textTheme: textTheme,
      primaryTextTheme: textTheme,

      // -----------------------------------------------------------------------
      // Scaffold — one step below surface so content panels lift off the page
      // -----------------------------------------------------------------------
      scaffoldBackgroundColor: isLight
          ? AppColors.surfaceContainerLow
          : AppColors.surfaceContainerLowDark,

      // -----------------------------------------------------------------------
      // Component themes
      // -----------------------------------------------------------------------
      appBarTheme: AppAppBarTheme.build(brightness: brightness),
      cardTheme: AppCardTheme.build(brightness: brightness),
      elevatedButtonTheme: AppElevatedButtonTheme.build(brightness: brightness),
      outlinedButtonTheme: AppOutlinedButtonTheme.build(brightness: brightness),
      textButtonTheme: AppTextButtonTheme.build(brightness: brightness),
      iconButtonTheme: AppIconButtonTheme.build(brightness: brightness),
      inputDecorationTheme:
          AppInputDecorationTheme.build(brightness: brightness),
      chipTheme: AppChipTheme.build(brightness: brightness),
      tooltipTheme: AppTooltipTheme.build(brightness: brightness),
      checkboxTheme: AppCheckboxTheme.build(brightness: brightness),
      radioTheme: AppRadioTheme.build(brightness: brightness),
      switchTheme: AppSwitchTheme.build(brightness: brightness),
      progressIndicatorTheme:
          AppProgressIndicatorTheme.build(brightness: brightness),
      navigationRailTheme: AppNavigationRailTheme.build(brightness: brightness),
      listTileTheme: AppListTileTheme.build(brightness: brightness),
      popupMenuTheme: AppPopupMenuTheme.build(brightness: brightness),
      scrollbarTheme: AppScrollbarTheme.build(brightness: brightness),
      tabBarTheme: AppTabBarTheme.build(brightness: brightness),

      // -----------------------------------------------------------------------
      // Inline — simple enough to not warrant a separate file
      // -----------------------------------------------------------------------
      dialogTheme: DialogThemeData(
        backgroundColor: isLight ? AppColors.surface : AppColors.surfaceDark,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isLight ? AppColors.surface : AppColors.surfaceDark,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sheet),
        clipBehavior: Clip.antiAlias,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isLight ? AppColors.inverseSurface : AppColors.inverseSurfaceDark,
        contentTextStyle: AppTypography.bodyMd.copyWith(
          color: isLight
              ? AppColors.onInverseSurface
              : AppColors.onInverseSurfaceDark,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        elevation: 4,
      ),

      dividerTheme: DividerThemeData(
        color:
            isLight ? AppColors.outlineVariant : AppColors.outlineVariantDark,
        thickness: 1,
        space: 1,
      ),

      iconTheme: IconThemeData(
        color: isLight
            ? AppColors.onSurfaceVariant
            : AppColors.onSurfaceVariantDark,
        size: 20,
      ),
    );
  }
}
