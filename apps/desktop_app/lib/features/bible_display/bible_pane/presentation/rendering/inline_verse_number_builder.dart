import 'package:flutter/material.dart';

import '../../../settings/bible_view_settings.dart';
import '../../../settings/domain/entities/bible_view_options.dart';

class InlineVerseNumberBuilder {
  static InlineSpan build({
    required BibleViewSettings settings,
    required int number,
    required InlineVerseNumberStyle style,
  }) {
    final label = number.toString();

    if (style == InlineVerseNumberStyle.simple) {
      return TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: settings.selectedRefColor,
          decoration: TextDecoration.underline,
        ),
      );
    }

    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2),
        decoration: BoxDecoration(
          color: settings.selectedRefColor.withAlpha(35),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 3,
            fontWeight: FontWeight.bold,
            color: settings.selectedRefColor,
          ),
        ),
      ),
    );
  }
}
