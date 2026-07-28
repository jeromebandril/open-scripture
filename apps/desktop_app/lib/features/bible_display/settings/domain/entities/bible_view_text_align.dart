import 'package:flutter/material.dart';

enum BibleViewTextAlign { left, center }

extension BibleViewTextAlignWire on BibleViewTextAlign {
  String get wire {
    switch (this) {
      case BibleViewTextAlign.left:
        return 'left';
      case BibleViewTextAlign.center:
        return 'center';
    }
  }

  static BibleViewTextAlign fromWire(String value) {
    switch (value) {
      case 'left':
        return BibleViewTextAlign.left;
      case 'center':
        return BibleViewTextAlign.center;
      default:
        return BibleViewTextAlign.left;
    }
  }
}

extension BibleViewTextAlignIcon on BibleViewTextAlign {
  IconData get icon {
    switch (this) {
      case BibleViewTextAlign.left:
        return Icons.align_horizontal_left_rounded;
      case BibleViewTextAlign.center:
        return Icons.align_horizontal_center_rounded;
    }
  }
}
