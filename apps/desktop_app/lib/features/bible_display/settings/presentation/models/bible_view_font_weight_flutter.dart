import 'dart:ui';

import '../../domain/entities/bible_view_font_weight.dart';

extension BibleViewFontWeightFlutter on BibleViewFontWeight {
  FontWeight toFlutter() {
    switch (this) {
      case BibleViewFontWeight.thin:
        return FontWeight.w100;
      case BibleViewFontWeight.extraLight:
        return FontWeight.w200;
      case BibleViewFontWeight.light:
        return FontWeight.w300;
      case BibleViewFontWeight.regular:
        return FontWeight.w400;
      case BibleViewFontWeight.medium:
        return FontWeight.w500;
      case BibleViewFontWeight.semiBold:
        return FontWeight.w600;
      case BibleViewFontWeight.bold:
        return FontWeight.w700;
      case BibleViewFontWeight.extraBold:
        return FontWeight.w800;
      case BibleViewFontWeight.black:
        return FontWeight.w900;
    }
  }
}
