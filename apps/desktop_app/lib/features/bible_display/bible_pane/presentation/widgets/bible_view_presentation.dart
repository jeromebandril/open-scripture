import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../customizer/domain/entities/presentation_verse_number_style.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../../customizer/presentation/models/bible_view_presentation_theme.dart';
import '../../../multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../rendering/verse_richtext_builder.dart';
import '../state/bible_pane_bloc.dart';

typedef _TranslationBlock = ({String subtitle, Widget content});

class BibleViewPresentation extends StatelessWidget {
  const BibleViewPresentation({super.key, required this.uniqueId});

  final int uniqueId;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final panes = context.read<MultiPaneManagerCubit>().state.panes;
    final thisPaneIndex = panes.indexWhere((e) => e.id == uniqueId);
    final isFirst = thisPaneIndex == 0;
    final isLast = thisPaneIndex == panes.length - 1;

    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
    final presentTheme =
        Theme.of(context).extension<BibleViewPresentationTheme>()!;

    return BlocBuilder<BiblePaneBloc, BiblePaneState>(
      buildWhen: (prev, curr) =>
          prev.reference != curr.reference || prev.content != curr.content,
      builder: (context, state) {
        final ref = state.reference;
        if (ref == null) return const SizedBox.shrink();

        final rangeToDisplay = state.content.getRefsInRange(ref);
        final isParallel = state.parallelOrder.length > 1;
        final translations = _buildTranslationBlocks(
          context: context,
          state: state,
          rangeToDisplay: rangeToDisplay,
          paneTheme: paneTheme,
          presentTheme: presentTheme,
        );

        return Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: isFirst ? screen.width * paneTheme.xPadding : 0,
                right: isLast ? screen.width * paneTheme.xPadding : 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 32,
                children: [
                  _buildTitle(ref, paneTheme, presentTheme),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: presentTheme.parallelDistance,
                    children: [
                      for (final block in translations)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (isParallel)
                              _buildTranslationSubtitle(
                                context,
                                block.subtitle,
                                paneTheme,
                                presentTheme,
                              ),
                            block.content,
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildTitle(
    BibleRef ref,
    BiblePaneGeneralTheme paneTheme,
    BibleViewPresentationTheme presentTheme,
  ) {
    // TODO: make english name be the fallback, prioritize the localized name
    final title = '${ref.book.englishName} ${ref.toStringChapterAndVerse()}';

    return Text(
      title,
      textAlign: presentTheme.titleAlignment,
      style: TextStyle(
        fontWeight: paneTheme.selectedRefFontWeight,
        fontFamily: paneTheme.referenceFont,
        color: paneTheme.accentColor,
        fontSize: 16,
      ),
    );
  }

  static Widget _buildTranslationSubtitle(
    BuildContext context,
    String subtitle,
    BiblePaneGeneralTheme paneTheme,
    BibleViewPresentationTheme presentTheme,
  ) {
    return Text(
      subtitle,
      textAlign: presentTheme.titleAlignment,
      style: TextStyle(
        color: paneTheme.enableCustomTheme
            ? paneTheme.refColor
            : Theme.of(context).colorScheme.primary,
        fontWeight: presentTheme.subtitleFontWeight,
        fontSize: 8,
      ),
    );
  }

  /// Builds one block per translation that has data for this reference.
  /// Verses are looked up by [BibleRef], not positional index, so a
  /// translation missing a verse mid-range can't shift every verse number
  /// after it out of alignment with the wrong text.
  static List<_TranslationBlock> _buildTranslationBlocks({
    required BuildContext context,
    required BiblePaneState state,
    required List<BibleRef> rangeToDisplay,
    required BiblePaneGeneralTheme paneTheme,
    required BibleViewPresentationTheme presentTheme,
  }) {
    final blocks = <_TranslationBlock>[];

    for (final id in state.parallelOrder) {
      final data = state.content.getParallelDataByBibleId(id);
      if (data == null || data.verses == null) continue;
      final verses = data.verses!;

      final spansByRef = <BibleRef, List<InlineSpan>>{
        for (final ref in rangeToDisplay)
          if (verses[ref] != null)
            ref: VerseSpanBuilder.build(
              context: context,
              spans: verses[ref]!.segments.expand((s) => s.spans).toList(),
            ),
      };

      final children = rangeToDisplay.length > 1
          ? _interleaveVerseNumbers(
              rangeToDisplay, spansByRef, paneTheme, presentTheme)
          : spansByRef.values.isEmpty
              ? const <InlineSpan>[]
              : spansByRef.values.first;

      final langNativeName = data.meta.langNativeName;
      final subtitle =
          '[${data.meta.name}${langNativeName != null ? ' - $langNativeName' : ''}]';

      blocks.add((
        subtitle: subtitle,
        content: Text.rich(
          TextSpan(
            style: TextStyle(fontWeight: paneTheme.textFontWeight),
            children: children,
          ),
          textAlign: presentTheme.textAlignment,
        ),
      ));
    }

    return blocks;
  }

  /// Interleaves each verse's spans with a leading verse-number marker.
  /// Only called when the range spans more than one verse — a single
  /// selected verse is shown without a number, since the title already
  /// states the full reference.
  static List<InlineSpan> _interleaveVerseNumbers(
    List<BibleRef> range,
    Map<BibleRef, List<InlineSpan>> spansByRef,
    BiblePaneGeneralTheme paneTheme,
    BibleViewPresentationTheme presentTheme,
  ) {
    final result = <InlineSpan>[];

    for (final ref in range) {
      final spans = spansByRef[ref];
      if (spans == null) continue;

      result.addAll([
        const TextSpan(text: '   '),
        _buildVerseNumber(ref.verseStart!, paneTheme, presentTheme),
        const TextSpan(text: ' '),
        ...spans,
      ]);
    }

    return result;
  }

  static InlineSpan _buildVerseNumber(
    int number,
    BiblePaneGeneralTheme paneTheme,
    BibleViewPresentationTheme presentTheme,
  ) {
    final label = number.toString();

    if (presentTheme.verseNumberStyle == PresentationVerseNumberStyle.simple) {
      return TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: paneTheme.accentColor,
          decoration: TextDecoration.underline,
        ),
      );
    }

    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2),
        decoration: BoxDecoration(
          color: paneTheme.accentColor.withAlpha(35),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: paneTheme.accentColor,
          ),
        ),
      ),
    );
  }
}
