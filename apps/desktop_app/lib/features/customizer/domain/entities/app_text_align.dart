import 'package:flutter/material.dart';

enum AppTextAlign { left, center }

extension AppTextAlignWire on AppTextAlign {
  String get wire {
    switch (this) {
      case AppTextAlign.left:
        return 'left';
      case AppTextAlign.center:
        return 'center';
    }
  }

  static AppTextAlign fromWire(String value) {
    switch (value) {
      case 'left':
        return AppTextAlign.left;
      case 'center':
        return AppTextAlign.center;
      default:
        return AppTextAlign.left;
    }
  }
}

extension AppTextAlignIcon on AppTextAlign {
  IconData get icon {
    switch (this) {
      case AppTextAlign.left:
        return Icons.align_horizontal_left_rounded;
      case AppTextAlign.center:
        return Icons.align_horizontal_center_rounded;
    }
  }
}
