import 'package:flutter/material.dart';

/// Design token layer for raw color values.
///
/// Naming convention:
/// - Base name = light theme value.
/// - `*Dark` suffix = dark theme counterpart.
///
/// Rules:
/// - Tokens are mapped to [ColorScheme] once in `app_theme.dart`.
abstract final class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Primary (blue accent)
  // ---------------------------------------------------------------------------

  static const Color primary = Color(0xFF2558C0);
  static const Color primaryDark = Color(0xFF7BAEF5);

  static const Color onPrimary = Color(0xFFF8F8F8);
  static const Color onPrimaryDark = Color(0xFF0A1828);

  static const Color primaryContainer = Color(0xFFD9E4FF);
  static const Color primaryContainerDark = Color(0xFF1A2535);

  static const Color onPrimaryContainer = Color(0xFF0C1A2E);
  static const Color onPrimaryContainerDark = Color(0xFFB8D0F0);

  // ---------------------------------------------------------------------------
  // Secondary (neutral mid-tone)
  // ---------------------------------------------------------------------------

  static const Color secondary = Color(0xFF5A5A5A);
  static const Color secondaryDark = Color(0xFFA8A8A8);

  static const Color onSecondary = Color(0xFFF8F8F8);
  static const Color onSecondaryDark = Color(0xFF0D0D0D);

  // ---------------------------------------------------------------------------
  // Tertiary (neutral support)
  // ---------------------------------------------------------------------------

  static const Color tertiary = Color(0xFF6E6E6E);
  static const Color tertiaryDark = Color(0xFF888888);

  static const Color onTertiary = Color(0xFFF8F8F8);
  static const Color onTertiaryDark = Color(0xFF0D0D0D);

  // ---------------------------------------------------------------------------
  // Surfaces — 5-level scale (lowest → highest container)
  // ---------------------------------------------------------------------------

  static const Color surface = Color(0xFFF4F4F4);
  static const Color surfaceDark = Color(0xFF181818);

  static const Color onSurface = Color(0xFF141414);
  static const Color onSurfaceDark = Color(0xFFEBEBEB);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowestDark = Color(0xFF0C0C0C);

  static const Color surfaceContainerLow = Color(0xFFF9F9F9);
  static const Color surfaceContainerLowDark = Color(0xFF141414);

  static const Color surfaceContainer = Color(0xFFF0F0F0);
  static const Color surfaceContainerDark = Color(0xFF181818);

  static const Color surfaceContainerHigh = Color(0xFFE8E8E8);
  static const Color surfaceContainerHighDark = Color(0xFF1C1C1C);

  static const Color surfaceContainerHighest = Color(0xFFE0E0E0);
  static const Color surfaceContainerHighestDark = Color(0xFF212121);

  static const Color onSurfaceVariant = Color(0xFF3A3A3A);
  static const Color onSurfaceVariantDark = Color(0xFFA0A0A0);

  // ---------------------------------------------------------------------------
  // Borders & dividers
  // ---------------------------------------------------------------------------

  static const Color outline = Color(0xFF8A8A8A);
  static const Color outlineDark = Color(0xFF505050);

  static const Color outlineVariant = Color(0xFFCCCCCC);
  static const Color outlineVariantDark = Color(0xFF333333);

  // ---------------------------------------------------------------------------
  // Feedback — Error
  // ---------------------------------------------------------------------------

  static const Color error = Color(0xFFB3261E);
  static const Color errorDark = Color(0xFFCF6679);

  static const Color onError = Color(0xFFF8F8F8);
  static const Color onErrorDark = Color(0xFF0D0D0D);

  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color errorContainerDark = Color(0xFF3D0A0F);

  static const Color onErrorContainer = Color(0xFF410E0B);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6);

  // ---------------------------------------------------------------------------
  // Feedback — Success (filled in to match error's tonal distance)
  // ---------------------------------------------------------------------------

  static const Color success = Color(0xFF1A6B3C);
  static const Color successDark = Color(0xFF4CAF7A);

  static const Color onSuccess = Color(0xFFF8F8F8);
  static const Color onSuccessDark = Color(0xFF0D0D0D);

  static const Color successContainer = Color(0xFFD3EFE1);
  static const Color successContainerDark = Color(0xFF0D2B1C);

  static const Color onSuccessContainer = Color(0xFF042517);
  static const Color onSuccessContainerDark = Color(0xFFD3EFE1);

  // ---------------------------------------------------------------------------
  // Feedback — Warning
  // ---------------------------------------------------------------------------

  static const Color warning = Color(0xFF875300);
  static const Color warningDark = Color(0xFFD4A030);

  static const Color onWarning = Color(0xFFF8F8F8);
  static const Color onWarningDark = Color(0xFF0D0D0D);

  static const Color warningContainer = Color(0xFFFFF0CC);
  static const Color warningContainerDark = Color(0xFF2B1F00);

  static const Color onWarningContainer = Color(0xFF2B1900);
  static const Color onWarningContainerDark = Color(0xFFFFF0CC);

  // ---------------------------------------------------------------------------
  // Feedback — Info (teal-blue, distinct from brand primary)
  // ---------------------------------------------------------------------------

  static const Color info = Color(0xFF0277BD);
  static const Color infoDark = Color(0xFF4DB8E8);

  static const Color onInfo = Color(0xFFF8F8F8);
  static const Color onInfoDark = Color(0xFF0D0D0D);

  static const Color infoContainer = Color(0xFFD0EEFF);
  static const Color infoContainerDark = Color(0xFF00344F);

  static const Color onInfoContainer = Color(0xFF002640);
  static const Color onInfoContainerDark = Color(0xFFD0EEFF);

  // ---------------------------------------------------------------------------
  // Inverse (snackbars, tooltips)
  // ---------------------------------------------------------------------------

  static const Color inverseSurface = Color(0xFF1A1A1A);
  static const Color inverseSurfaceDark = Color(0xFFEBEBEB);

  static const Color onInverseSurface = Color(0xFFECECEC);
  static const Color onInverseSurfaceDark = Color(0xFF101010);

  static const Color inversePrimary = Color(0xFF7BAEF5);
  static const Color inversePrimaryDark = Color(0xFF1A2535);

  // ---------------------------------------------------------------------------
  // Misc
  // ---------------------------------------------------------------------------

  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // ---------------------------------------------------------------------------
  // Neutral scale — derived from the surface steps above.
  // Used by component themes for disabled states and internal UI chrome.
  // ---------------------------------------------------------------------------

  static const Color grey50 = Color(0xFFF9F9F9); // surfaceContainerLow
  static const Color grey100 = Color(0xFFF4F4F4); // surface
  static const Color grey200 = Color(0xFFE8E8E8); // surfaceContainerHigh
  static const Color grey300 = Color(0xFFD0D0D0);
  static const Color grey400 = Color(0xFFB0B0B0);
  static const Color grey500 = Color(0xFF8A8A8A); // outline
  static const Color grey600 = Color(0xFF6E6E6E); // tertiary
  static const Color grey700 = Color(0xFF505050); // outlineDark
  static const Color grey800 = Color(0xFF333333); // outlineVariantDark
  static const Color grey900 = Color(0xFF1A1A1A); // inverseSurface

  // ---------------------------------------------------------------------------
  // Opacity helpers (used by AppShadows and component hover overlays)
  // ---------------------------------------------------------------------------

  static Color withOpacity(Color color, double opacity) =>
      color.withValues(alpha: opacity);

  static Color blackOverlay(double opacity) =>
      shadow.withValues(alpha: opacity);
}
