import 'package:flutter/material.dart';

abstract final class AppTypography {
  AppTypography._();

  static const String fontFamilyDisplay = 'General Sans';
  static const String fontFamilyBody = 'General Sans';
  static const String fontFamilyMono = 'IBM Plex Mono';

  // Display
  static const TextStyle display2xl = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 56,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.0,
  );
  static const TextStyle displayXl = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 48,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.8,
  );
  static const TextStyle displayLg = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 40,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.6,
  );
  static const TextStyle displayMd = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
  );
  static const TextStyle displaySm = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  // Heading
  static const TextStyle headingXl = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle headingLg = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle headingMd = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle headingSm = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle headingXs = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  // Body
  static const TextStyle bodyXl = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
  static const TextStyle bodySm = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  static const TextStyle bodyXs = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );

  // Label
  static const TextStyle labelLg = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle labelMd = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle labelSm = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle labelXs = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
}
