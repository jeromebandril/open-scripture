import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/customizer/domain/entities/app_text_align.dart';

class BibleViewPresentationThemeSettings extends Equatable {
  final AppTextAlign textAlign;

  const BibleViewPresentationThemeSettings({
    this.textAlign = AppTextAlign.left,
  });

  @override
  List<Object?> get props => [
        textAlign,
      ];

  Map<String, dynamic> toJson() => {
        'textAlign': textAlign.wire,
      };

  BibleViewPresentationThemeSettings copyWith({AppTextAlign? textAlign}) {
    return BibleViewPresentationThemeSettings(
      textAlign: textAlign ?? this.textAlign,
    );
  }

  static BibleViewPresentationThemeSettings fromJson(
      Map<String, dynamic> json) {
    return BibleViewPresentationThemeSettings(
        textAlign: AppTextAlignWire.fromWire(json['textAlign'] as String));
  }
}
