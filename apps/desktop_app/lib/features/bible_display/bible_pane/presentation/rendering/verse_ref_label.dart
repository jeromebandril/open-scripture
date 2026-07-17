import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../../customizer/presentation/models/bible_view_list_theme.dart';
import '../../../../customizer/presentation/state/customizer_cubit.dart';

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
    final useCustom =
        context.select((CustomizerCubit c) => c.state.pane.enableCustomTheme);
    final bTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
    final listTheme = Theme.of(context).extension<BibleViewListTheme>()!;

    return TextStyle(
      decoration: listTheme.underlineRef,
      decorationColor: isHighlighted
          ? bTheme.accentColor
          : useCustom
              ? bTheme.refColor
              : Theme.of(context).colorScheme.secondary,
      height: 1.25,
      fontFamily: bTheme.referenceFont,
      fontWeight:
          isHighlighted ? bTheme.selectedRefFontWeight : bTheme.refFontWeight,
      color: isHighlighted
          ? bTheme.accentColor
          : useCustom
              ? bTheme.refColor
              : Theme.of(context).colorScheme.tertiary,
    );
  }
}
