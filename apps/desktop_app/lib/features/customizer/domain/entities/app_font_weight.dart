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
        return AppFontWeight.regular;
    }
  }
}
