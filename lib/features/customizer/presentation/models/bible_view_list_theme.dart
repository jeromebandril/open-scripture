import 'package:flutter/material.dart';

import '../../domain/entities/bible_view_list_theme_settings.dart';

@immutable
class BibleViewListTheme extends ThemeExtension<BibleViewListTheme> {
  final TextDecoration underlineRef;

  const BibleViewListTheme({
    required this.underlineRef,
  });

  @override
  ThemeExtension<BibleViewListTheme> copyWith({
    TextDecoration? underlineRef,
  }) {
    return BibleViewListTheme(
      underlineRef: underlineRef ?? this.underlineRef,
    );
  }

  @override
  ThemeExtension<BibleViewListTheme> lerp(
      covariant ThemeExtension<BibleViewListTheme>? other, double t) {
    if (other is! BibleViewListTheme) return this;
    return BibleViewListTheme(
      underlineRef: underlineRef,
    );
  }
}

extension BibleViewListThemeX on BibleViewListThemeSettings {
  BibleViewListTheme toExtension() => BibleViewListTheme(
        underlineRef:
            underlineRef ? TextDecoration.underline : TextDecoration.none,
      );
}
