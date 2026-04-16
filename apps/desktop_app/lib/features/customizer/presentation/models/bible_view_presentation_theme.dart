import 'package:flutter/material.dart';
import 'package:open_scripture/features/customizer/domain/entities/bible_pane_presentation_theme_settings.dart';
import 'package:open_scripture/features/customizer/presentation/models/app_font_weight.dart';
import 'package:open_scripture/features/customizer/presentation/models/app_text_alignment.dart';

@immutable
class BibleViewPresentationTheme
    extends ThemeExtension<BibleViewPresentationTheme> {
  final TextAlign textAlignment;
  final FontWeight subtitleFontWeight;

  const BibleViewPresentationTheme({
    required this.textAlignment,
    required this.subtitleFontWeight,
  });

  @override
  ThemeExtension<BibleViewPresentationTheme> copyWith({
    TextAlign? textAlignment,
    FontWeight? subtitleFontWeight,
  }) {
    return BibleViewPresentationTheme(
      textAlignment: textAlignment ?? this.textAlignment,
      subtitleFontWeight: subtitleFontWeight ?? this.subtitleFontWeight,
    );
  }

  @override
  ThemeExtension<BibleViewPresentationTheme> lerp(
      covariant ThemeExtension<BibleViewPresentationTheme>? other, double t) {
    if (other is! BibleViewPresentationTheme) return this;
    return BibleViewPresentationTheme(
      textAlignment: textAlignment,
      subtitleFontWeight: subtitleFontWeight,
    );
  }
}

extension BibleViewPresentationThemeX on BibleViewPresentationThemeSettings {
  BibleViewPresentationTheme toExtension() => BibleViewPresentationTheme(
        textAlignment: textAlign.toFlutter(),
        subtitleFontWeight: subtitleFontWeight.toFlutter(),
      );
}
