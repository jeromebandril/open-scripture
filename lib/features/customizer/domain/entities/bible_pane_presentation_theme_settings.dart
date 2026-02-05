import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/entities/app_text_alignment.dart';

class BiblePanePresentationThemeSettings extends Equatable {
  final AppTextAlignment textAlignment;

  const BiblePanePresentationThemeSettings({
    this.textAlignment = AppTextAlignment.left,
  });

  @override
  List<Object?> get props => [
        textAlignment,
      ];
}
