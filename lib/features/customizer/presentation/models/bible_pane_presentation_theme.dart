import 'package:flutter/material.dart';

@immutable
class BiblePanePresentationTheme
    extends ThemeExtension<BiblePanePresentationTheme> {
  final TextAlign textAlignment;

  const BiblePanePresentationTheme({
    required this.textAlignment,
  });

  @override
  ThemeExtension<BiblePanePresentationTheme> copyWith({
    TextAlign? textAlignment,
  }) {
    return BiblePanePresentationTheme(
      textAlignment: textAlignment ?? this.textAlignment,
    );
  }

  @override
  ThemeExtension<BiblePanePresentationTheme> lerp(
      covariant ThemeExtension<BiblePanePresentationTheme>? other, double t) {
    if (other is! BiblePanePresentationTheme) return this;
    return BiblePanePresentationTheme(
      textAlignment: textAlignment,
    );
  }
}
