import 'package:flutter/material.dart';

import '../../../settings/domain/entities/bible_view_options.dart';
import '../../../settings/presentation/widgets/bible_view_settings_provider.dart';

class InlineVerseNumberBuilder {
  static InlineSpan build({
    required BuildContext context,
    required int number,
  }) {
    final viewSettings = BibleViewSettingsScope.of(context);
    final viewColors = BibleViewSettingsScope.colorschemeOf(context);

    final label = number.toString();

    if (viewSettings.inlineVerseNumberStyle == InlineVerseNumberStyle.simple) {
      return TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: viewColors.selectedRefColor,
          decoration: TextDecoration.underline,
        ),
      );
    }

    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2),
        decoration: BoxDecoration(
          color: viewColors.selectedRefColor.withAlpha(35),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 3,
            fontWeight: FontWeight.bold,
            color: viewColors.selectedRefColor,
          ),
        ),
      ),
    );
  }
}
