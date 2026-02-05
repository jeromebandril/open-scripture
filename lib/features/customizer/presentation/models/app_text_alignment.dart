import 'package:flutter/painting.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/entities/app_text_alignment.dart';

extension AppTextAlignmentFlutter on AppTextAlignment {
  TextAlign toFlutter() {
    switch (this) {
      case AppTextAlignment.left:
        return TextAlign.left;
      case AppTextAlignment.center:
        return TextAlign.center;
    }
  }
}
