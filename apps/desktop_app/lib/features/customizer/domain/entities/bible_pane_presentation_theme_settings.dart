import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/customizer/domain/entities/app_font_weight.dart';
import 'package:open_scripture/features/customizer/domain/entities/app_text_align.dart';

class BibleViewPresentationThemeSettings extends Equatable {
  final AppTextAlign textAlign;
  final AppFontWeight subtitleFontWeight;

  const BibleViewPresentationThemeSettings({
    this.textAlign = AppTextAlign.center,
    this.subtitleFontWeight = AppFontWeight.semiBold,
  });

  @override
  List<Object?> get props => [
        textAlign,
        subtitleFontWeight,
      ];

  Map<String, dynamic> toJson() => {
        'textAlign': textAlign.wire,
        'subtitleFontWeight': subtitleFontWeight.wire,
      };

  BibleViewPresentationThemeSettings copyWith({
    AppTextAlign? textAlign,
    AppFontWeight? subtitleFontWeight,
  }) {
    return BibleViewPresentationThemeSettings(
      textAlign: textAlign ?? this.textAlign,
      subtitleFontWeight: subtitleFontWeight ?? this.subtitleFontWeight,
    );
  }

  static BibleViewPresentationThemeSettings fromJson(
      Map<String, dynamic> json) {
    return BibleViewPresentationThemeSettings(
      textAlign: AppTextAlignWire.fromWire(json['textAlign'] as String),
      subtitleFontWeight:
          AppFontWeightWire.fromWire(json['subtitleFontWeight'] as String),
    );
  }
}
