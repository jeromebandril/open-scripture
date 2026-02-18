import 'package:flutter/material.dart';
import 'package:open_scripture/features/customizer/domain/entities/bible_pane_presentation_theme_settings.dart';
import 'package:open_scripture/features/customizer/presentation/models/app_text_alignment.dart';

@immutable
class BibleViewPresentationTheme
    extends ThemeExtension<BibleViewPresentationTheme> {
  final TextAlign textAlignment;

  const BibleViewPresentationTheme({
    required this.textAlignment,
  });

  @override
  ThemeExtension<BibleViewPresentationTheme> copyWith({
    TextAlign? textAlignment,
  }) {
    return BibleViewPresentationTheme(
      textAlignment: textAlignment ?? this.textAlignment,
    );
  }

  @override
  ThemeExtension<BibleViewPresentationTheme> lerp(
      covariant ThemeExtension<BibleViewPresentationTheme>? other, double t) {
    if (other is! BibleViewPresentationTheme) return this;
    return BibleViewPresentationTheme(
      textAlignment: textAlignment,
    );
  }
}

extension BibleViewPresentationThemeX on BibleViewPresentationThemeSettings {
  BibleViewPresentationTheme toExtension() => BibleViewPresentationTheme(
        textAlignment: textAlign.toFlutter(),
      );
}
