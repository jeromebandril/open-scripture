import 'package:flutter/material.dart';

import '../../domain/entities/display_options.dart';

extension AppFontWeightFlutter on AppFontWeight {
  FontWeight toFlutter() => switch (this) {
        AppFontWeight.thin => FontWeight.w100,
        AppFontWeight.extraLight => FontWeight.w200,
        AppFontWeight.light => FontWeight.w300,
        AppFontWeight.regular => FontWeight.w400,
        AppFontWeight.medium => FontWeight.w500,
        AppFontWeight.semiBold => FontWeight.w600,
        AppFontWeight.bold => FontWeight.w700,
        AppFontWeight.extraBold => FontWeight.w800,
        AppFontWeight.black => FontWeight.w900,
      };
}

extension AppTextAlignFlutter on AppTextAlign {
  TextAlign toFlutter() => switch (this) {
        AppTextAlign.left => TextAlign.left,
        AppTextAlign.center => TextAlign.center,
        AppTextAlign.right => TextAlign.right,
      };
}

extension AppTextAlignIcon on AppTextAlign {
  IconData get icon => switch (this) {
        AppTextAlign.left => Icons.format_align_left_rounded,
        AppTextAlign.center => Icons.format_align_center_rounded,
        AppTextAlign.right => Icons.format_align_right_rounded,
      };
}
