import 'dart:ui';

import '../../domain/entities/app_font_weight.dart';

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
