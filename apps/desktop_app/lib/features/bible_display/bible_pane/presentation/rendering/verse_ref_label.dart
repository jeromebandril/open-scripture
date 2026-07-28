import 'package:flutter/material.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../settings/presentation/models/bible_view_font_weight_flutter.dart';
import '../../../settings/presentation/widgets/bible_view_settings_provider.dart';

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

    return TextStyle(
      decoration: viewSettings.underlineRefs ? TextDecoration.underline : null,
      decorationColor: isHighlighted
          ? viewSettings.selectedRefColor
          : viewSettings.useAppTheme
              ? Theme.of(context).colorScheme.secondary
              : viewSettings.refColor,
      height: 1.25,
      fontFamily: viewSettings.refFontFamily,
      fontWeight: (isHighlighted
              ? viewSettings.selectedRefFontWeight
              : viewSettings.refFontWeight)
          .toFlutter(),
      color: isHighlighted
          ? viewSettings.selectedRefColor
          : viewSettings.useAppTheme
              ? Theme.of(context).colorScheme.tertiary
              : viewSettings.refColor,
    );
  }
}
