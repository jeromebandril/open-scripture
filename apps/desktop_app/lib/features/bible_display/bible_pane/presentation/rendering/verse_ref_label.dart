import 'package:flutter/material.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../customizer/presentation/models/app_font_weight.dart';
import '../../../settings/bible_view_settings_provider.dart';

/// How a verse's leading reference/number should look
abstract final class VerseRefLabel {
  // TODO: uhm this part is useful only for bible list view
  static String text(
    BibleRef ref, {
    required bool isHighlighted,
    required bool showFullRefAlways,
  }) {
    return isHighlighted || showFullRefAlways
        ? ref.toString()
        : '${ref.verseStart!}';
  }

  static TextStyle style(BuildContext context, {required bool isHighlighted}) {
    final viewSettings = BibleViewSettingsScope.of(context);
    final useCustom = viewSettings.enableCustomTheme;

    return TextStyle(
      decoration: viewSettings.underlineRef ? TextDecoration.underline : null,
      decorationColor: isHighlighted
          ? viewSettings.accentColor
          : useCustom
              ? viewSettings.refColor
              : Theme.of(context).colorScheme.secondary,
      height: 1.25,
      fontFamily: viewSettings.referenceFont,
      fontWeight: (isHighlighted
              ? viewSettings.selectedRefFontWeight
              : viewSettings.refFontWeight)
          .toFlutter(),
      color: isHighlighted
          ? viewSettings.accentColor
          : useCustom
              ? viewSettings.refColor
              : Theme.of(context).colorScheme.tertiary,
    );
  }
}
