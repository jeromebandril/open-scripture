import 'package:flutter/painting.dart';
import '../../domain/entities/app_text_align.dart';

extension AppTextAlignmentFlutter on AppTextAlign {
  TextAlign toFlutter() {
    switch (this) {
      case AppTextAlign.left:
        return TextAlign.left;
      case AppTextAlign.center:
        return TextAlign.center;
    }
  }
}
