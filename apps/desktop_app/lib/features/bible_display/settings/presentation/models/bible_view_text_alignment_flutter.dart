import 'package:flutter/painting.dart';
import '../../domain/entities/bible_view_text_align.dart';

extension BibleViewTextAlignmentFlutter on BibleViewTextAlign {
  TextAlign toFlutter() {
    switch (this) {
      case BibleViewTextAlign.left:
        return TextAlign.left;
      case BibleViewTextAlign.center:
        return TextAlign.center;
    }
  }
}
