import 'package:flutter/material.dart';

/// Typography tokens.
///
/// Defines the complete type scale as [TextStyle] constants.
/// All styles are font-family agnostic by default — the font is
/// injected once via [ThemeData.textTheme] in `app_theme.dart`.
///
/// Usage:
/// ```dart
/// Text('Hello', style: AppTypography.headingLg)
/// ```
abstract final class AppTypography {
  AppTypography._();

  // ---------------------------------------------------------------------------
  // Font families
  // ---------------------------------------------------------------------------

  static const String fontFamilyDisplay = 'General Sans';
  static const String fontFamilyBody = 'General Sans';
  static const String fontFamilyMono = 'IBM Plex Mono';

  // ---------------------------------------------------------------------------
  // Display (hero headlines, splash screens)
  // ---------------------------------------------------------------------------

  static const TextStyle display2xl = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 72,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -1.5,
  );

  static const TextStyle displayXl = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 60,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -1.2,
  );

  static const TextStyle displayLg = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.96,
  );

  static const TextStyle displayMd = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.72,
  );

  static const TextStyle displaySm = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.3,
  );

  // ---------------------------------------------------------------------------
  // Heading (section titles, page headers)
  // ---------------------------------------------------------------------------

  static const TextStyle headingXl = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.24,
  );

  static const TextStyle headingLg = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: -0.2,
  );

  static const TextStyle headingMd = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle headingSm = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle headingXs = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ---------------------------------------------------------------------------
  // Body (paragraphs, descriptions)
  // ---------------------------------------------------------------------------

  static const TextStyle bodyXl = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyXs = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ---------------------------------------------------------------------------
  // Label (buttons, form labels, chips)
  // ---------------------------------------------------------------------------

  static const TextStyle labelLg = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.2,
  );

  static const TextStyle labelXs = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.3,
  );

  // ---------------------------------------------------------------------------
  // Caption / overline (supporting metadata, timestamps)
  // ---------------------------------------------------------------------------

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.4,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 1.2,
  );

  // ---------------------------------------------------------------------------
  // Code / mono
  // ---------------------------------------------------------------------------

  static const TextStyle codeMd = TextStyle(
    fontFamily: fontFamilyMono,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: -0.2,
  );

  static const TextStyle codeSm = TextStyle(
    fontFamily: fontFamilyMono,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -0.1,
  );
}
