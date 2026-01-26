import 'package:flutter/material.dart';

enum AppFontWeight {
  thin,
  extraLight,
  light,
  regular,
  medium,
  semiBold,
  bold,
  extraBold,
  black,
}

extension AppFontWeightWire on AppFontWeight {
  /// Stable value for JSON/preferences.
  String get wire {
    switch (this) {
      case AppFontWeight.thin:
        return 'thin';
      case AppFontWeight.extraLight:
        return 'extraLight';
      case AppFontWeight.light:
        return 'light';
      case AppFontWeight.regular:
        return 'regular';
      case AppFontWeight.medium:
        return 'medium';
      case AppFontWeight.semiBold:
        return 'semiBold';
      case AppFontWeight.bold:
        return 'bold';
      case AppFontWeight.extraBold:
        return 'extraBold';
      case AppFontWeight.black:
        return 'black';
    }
  }

  static AppFontWeight fromWire(String value) {
    switch (value) {
      case 'thin':
        return AppFontWeight.thin;
      case 'extraLight':
        return AppFontWeight.extraLight;
      case 'light':
        return AppFontWeight.light;
      case 'regular':
        return AppFontWeight.regular;
      case 'medium':
        return AppFontWeight.medium;
      case 'semiBold':
        return AppFontWeight.semiBold;
      case 'bold':
        return AppFontWeight.bold;
      case 'extraBold':
        return AppFontWeight.extraBold;
      case 'black':
        return AppFontWeight.black;
      default:
        return AppFontWeight.regular; // safe default
    }
  }
}

extension AppFontWeightFlutter on AppFontWeight {
  FontWeight toFlutter() {
    switch (this) {
      case AppFontWeight.thin:
        return FontWeight.w100;
      case AppFontWeight.extraLight:
        return FontWeight.w200;
      case AppFontWeight.light:
        return FontWeight.w300;
      case AppFontWeight.regular:
        return FontWeight.w400;
      case AppFontWeight.medium:
        return FontWeight.w500;
      case AppFontWeight.semiBold:
        return FontWeight.w600;
      case AppFontWeight.bold:
        return FontWeight.w700;
      case AppFontWeight.extraBold:
        return FontWeight.w800;
      case AppFontWeight.black:
        return FontWeight.w900;
    }
  }
}
