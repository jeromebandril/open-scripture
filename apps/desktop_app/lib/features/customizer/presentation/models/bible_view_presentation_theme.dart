import 'package:flutter/material.dart';

import '../../domain/entities/bible_pane_presentation_theme_settings.dart';
import '../../domain/entities/presentation_verse_number_style.dart';
import 'app_font_weight.dart';
import 'app_text_alignment.dart';

@immutable
class BibleViewPresentationTheme
    extends ThemeExtension<BibleViewPresentationTheme> {
  final TextAlign titleAlignment;
  final TextAlign textAlignment;
  final FontWeight subtitleFontWeight;
  final PresentationVerseNumberStyle verseNumberStyle;
  final double parallelDistance;

  const BibleViewPresentationTheme({
    required this.titleAlignment,
    required this.textAlignment,
    required this.subtitleFontWeight,
    required this.verseNumberStyle,
    required this.parallelDistance,
  });

  @override
  ThemeExtension<BibleViewPresentationTheme> copyWith({
    TextAlign? titleAlignment,
    TextAlign? textAlignment,
    FontWeight? subtitleFontWeight,
    PresentationVerseNumberStyle? verseNumberStyle,
    double? parallelDistance,
  }) {
    return BibleViewPresentationTheme(
      titleAlignment: titleAlignment ?? this.titleAlignment,
      textAlignment: textAlignment ?? this.textAlignment,
      subtitleFontWeight: subtitleFontWeight ?? this.subtitleFontWeight,
      verseNumberStyle: verseNumberStyle ?? this.verseNumberStyle,
      parallelDistance: parallelDistance ?? this.parallelDistance,
    );
  }

  @override
  ThemeExtension<BibleViewPresentationTheme> lerp(
      covariant ThemeExtension<BibleViewPresentationTheme>? other, double t) {
    if (other is! BibleViewPresentationTheme) return this;
    return BibleViewPresentationTheme(
      titleAlignment: titleAlignment,
      textAlignment: textAlignment,
      subtitleFontWeight: subtitleFontWeight,
      verseNumberStyle: verseNumberStyle,
      parallelDistance: parallelDistance,
    );
  }
}

extension BibleViewPresentationThemeX on BibleViewPresentationThemeSettings {
  BibleViewPresentationTheme toExtension() => BibleViewPresentationTheme(
        titleAlignment: titleTextAlign.toFlutter(),
        textAlignment: textAlign.toFlutter(),
        subtitleFontWeight: subtitleFontWeight.toFlutter(),
        verseNumberStyle: verseNumberStyle,
        parallelDistance: parallelDistance,
      );
}
