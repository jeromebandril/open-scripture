import 'package:flutter/material.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/presentation/models/display_option_flutter.dart';
import '../../../colorschemes/domain/entities/bible_view_colorscheme.dart';
import '../../../settings/bible_view_settings.dart';
import '../../../settings/domain/entities/bible_view_options.dart';
import '../../domain/display_mode.dart';
import '../widgets/bible_pane.dart';

extension _StringCasingExtension on String {
  String toSentenceCase() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}

/// How a verse's leading reference/number should look
abstract final class VerseRefLabel {
  static String text(
    BibleRef ref, {
    required BibleViewSettings viewSettings,
    required DisplayMode displayMode,
    required bool isSelected,
  }) {
    return switch (displayMode) {
      DisplayMode.list => _listText(ref, viewSettings, isSelected),
      // TODO: prioritize the localized name and make english the fallback
      DisplayMode.presentation =>
        '${ref.book.englishName} ${ref.toStringChapterAndVerse()}',
      DisplayMode.prose => '${ref.verseStart}',
    };
  }

  static String _listText(
    BibleRef ref,
    BibleViewSettings viewSettings,
    bool isSelected,
  ) {
    final showFullRef = isSelected || viewSettings.showAlwaysFullRef;
    final text = showFullRef ? ref.toString() : '${ref.verseStart!}';

    return switch (viewSettings.listVerseRefCase) {
      TextCase.sentenceCase => text.toSentenceCase(),
      TextCase.uppercase => text.toUpperCase(),
    };
  }

  static TextStyle style(
    BibleViewSettings viewSettings,
    BibleViewColorscheme colors, {
    required DisplayMode displayMode,
    required bool isSelected,
  }) {
    if (displayMode == DisplayMode.presentation) {
      return TextStyle(
        fontSize: initialFontSize + 1,
        fontFamily: viewSettings.refFontFamily,
        fontWeight: viewSettings.selectedRefFontWeight.toFlutter(),
        color: colors.selectedRefColor,
      );
    }

    final color = isSelected ? colors.selectedRefColor : colors.refColor;
    final weight = isSelected
        ? viewSettings.selectedRefFontWeight
        : viewSettings.refFontWeight;

    return TextStyle(
      fontSize: initialFontSize + viewSettings.listRefSize.refSizeOffset,
      height: 1.25,
      fontFamily: viewSettings.refFontFamily,
      fontWeight: weight.toFlutter(),
      color: color,
      decoration: viewSettings.underlineRefs ? TextDecoration.underline : null,
      decorationColor: color,
    );
  }
}
