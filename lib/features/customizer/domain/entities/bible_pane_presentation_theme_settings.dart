import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/entities/app_text_alignment.dart';

class BibleViewPresentationThemeSettings extends Equatable {
  final AppTextAlignment textAlignment;

  const BibleViewPresentationThemeSettings({
    this.textAlignment = AppTextAlignment.left,
  });

  @override
  List<Object?> get props => [
        textAlignment,
      ];

  Map<String, dynamic> toJson() => {
        'textAlignment': textAlignment.wire,
      };

  BibleViewPresentationThemeSettings copyWith(
      {AppTextAlignment? textAlignment}) {
    return BibleViewPresentationThemeSettings(
      textAlignment: textAlignment ?? this.textAlignment,
    );
  }

  static BibleViewPresentationThemeSettings fromJson(
      Map<String, dynamic> json) {
    return BibleViewPresentationThemeSettings(
        textAlignment:
            AppTextAlignmentWire.fromWire(json['textAlign'] as String));
  }
}
