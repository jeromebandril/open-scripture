import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/customizer/domain/entities/app_font_weight.dart';
import 'package:open_scripture/features/customizer/domain/entities/app_text_align.dart';
import 'package:open_scripture/features/customizer/domain/entities/presentation_verse_number_style.dart';

class BibleViewPresentationThemeSettings extends Equatable {
  final AppTextAlign titleTextAlign;
  final AppTextAlign textAlign;
  final AppFontWeight subtitleFontWeight;
  final PresentationVerseNumberStyle verseNumberStyle;
  final double parallelDistance;

  const BibleViewPresentationThemeSettings({
    this.titleTextAlign = AppTextAlign.center,
    this.textAlign = AppTextAlign.center,
    this.subtitleFontWeight = AppFontWeight.semiBold,
    this.verseNumberStyle = PresentationVerseNumberStyle.normal,
    this.parallelDistance = 32,
  });

  @override
  List<Object?> get props => [
        titleTextAlign,
        textAlign,
        subtitleFontWeight,
        verseNumberStyle,
        parallelDistance,
      ];

  Map<String, dynamic> toJson() => {
        'titleTextAlign': titleTextAlign.wire,
        'textAlign': textAlign.wire,
        'subtitleFontWeight': subtitleFontWeight.wire,
        'verseNumberStyle': verseNumberStyle.wire,
        'parallelDistance': parallelDistance,
      };

  BibleViewPresentationThemeSettings copyWith({
    AppTextAlign? titleTextAlign,
    AppTextAlign? textAlign,
    AppFontWeight? subtitleFontWeight,
    PresentationVerseNumberStyle? verseNumberStyle,
    double? parallelDistance,
  }) {
    return BibleViewPresentationThemeSettings(
      titleTextAlign: titleTextAlign ?? this.titleTextAlign,
      textAlign: textAlign ?? this.textAlign,
      subtitleFontWeight: subtitleFontWeight ?? this.subtitleFontWeight,
      verseNumberStyle: verseNumberStyle ?? this.verseNumberStyle,
      parallelDistance: parallelDistance ?? this.parallelDistance,
    );
  }

  static BibleViewPresentationThemeSettings fromJson(
      Map<String, dynamic> json) {
    return BibleViewPresentationThemeSettings(
      titleTextAlign:
          AppTextAlignWire.fromWire(json['titleTextAlign'] as String),
      textAlign: AppTextAlignWire.fromWire(json['textAlign'] as String),
      subtitleFontWeight:
          AppFontWeightWire.fromWire(json['subtitleFontWeight'] as String),
      verseNumberStyle: PresentationVerseNumberStyleWire.fromWire(
          json['verseNumberStyle'] as String),
      parallelDistance: json['parallelDistance'] as double,
    );
  }
}
