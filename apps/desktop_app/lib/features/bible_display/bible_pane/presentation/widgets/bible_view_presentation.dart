import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/rendering/verse_richtext_builder.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/features/customizer/domain/entities/presentation_verse_number_style.dart';
import 'package:open_scripture/features/customizer/presentation/models/bible_pane_general_theme.dart';
import 'package:open_scripture/features/customizer/presentation/models/bible_view_presentation_theme.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';

class BibleViewPresentation extends StatelessWidget {
  const BibleViewPresentation({super.key, required this.uniqueId});

  final int uniqueId;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
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
        if (state.reference == null) return const SizedBox.shrink();
        final ref = state.reference!;

        // TODO: make english name be the fallback, prioritize the localized name
        final displayTitle =
            '${ref.book.englishName} ${ref.toStringChapterAndVerse()}';

        final rangeToDisplay = state.content.getRefsInRange(ref);
        final isParallel = state.parallelOrder.length > 1;

        final views = _buildParallelViews(
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
                  Text(
                    displayTitle,
                    textAlign: presentTheme.titleAlignment,
                    style: TextStyle(
                      fontWeight: paneTheme.selectedRefFontWeight,
                      fontFamily: paneTheme.referenceFont,
                      color: paneTheme.accentColor,
                      fontSize: 16,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: presentTheme.parallelDistance,
                    children: views.map((entry) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (isParallel)
                            Text(
                              '(${entry.key})',
                              textAlign: presentTheme.titleAlignment,
                              style: TextStyle(
                                color: paneTheme.enableCustomTheme
                                    ? paneTheme.refColor
                                    : Theme.of(context).colorScheme.primary,
                                fontWeight: presentTheme.subtitleFontWeight,
                                fontSize: 8,
                              ),
                            ),
                          entry.value,
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<MapEntry<String, Widget>> _buildParallelViews({
    required BuildContext context,
    required BiblePaneState state,
    required List<BibleRef> rangeToDisplay,
    required BiblePaneGeneralTheme paneTheme,
    required BibleViewPresentationTheme presentTheme,
  }) {
    return state.parallelOrder
        .where(
            (id) => state.content.getParallelDataByBibleId(id)?.verses != null)
        .map((id) {
      final value = state.content.getParallelDataByBibleId(id)!;
      final verses = value.verses!.entries
          .where((e) => rangeToDisplay.contains(e.key))
          .toList();

      // Each verse produces a List<InlineSpan>; presentation mode flattens
      // segments since it renders a flowing paragraph, not stacked VerseWidgets.
      // Heading/paragraph-break handling from VerseSegment is a future TODO here.
      final verseSpans = verses.map((entry) {
        final spans = entry.value.segments.expand((s) => s.spans).toList();
        return VerseSpanBuilder.build(
          context: context,
          spans: spans,
          // Word tap is not wired in presentation mode
        );
      }).toList();

      final children = rangeToDisplay.length > 1
          ? _interleavedWithVerseNumbers(
              rangeToDisplay, verseSpans, context, paneTheme, presentTheme)
          : verseSpans.isEmpty
              ? const <InlineSpan>[]
              : verseSpans.first;

      return MapEntry(
        '${value.meta.name} - ${value.meta.langNativeName}',
        Text.rich(
          TextSpan(
            style: TextStyle(fontWeight: paneTheme.textFontWeight),
            children: children,
          ),
          textAlign: presentTheme.textAlignment,
        ),
      );
    }).toList();
  }

  List<InlineSpan> _interleavedWithVerseNumbers(
    List<BibleRef> range,
    List<List<InlineSpan>> verseSpans, // one List<InlineSpan> per verse
    BuildContext context,
    BiblePaneGeneralTheme paneTheme,
    BibleViewPresentationTheme presentTheme,
  ) {
    final result = <InlineSpan>[];
    for (int i = 0; i < range.length; i++) {
      result.addAll([
        const TextSpan(text: '   '),
        _buildVerseNumber(range[i].verseStart!, paneTheme, presentTheme),
        const TextSpan(text: ' '),
        // Spread the spans for this verse rather than wrapping in a parent
        ...verseSpans[i],
      ]);
    }
    return result;
  }

  InlineSpan _buildVerseNumber(
    int number,
    BiblePaneGeneralTheme paneTheme,
    BibleViewPresentationTheme presentTheme,
  ) {
    final label = number.toString();

    if (presentTheme.verseNumberStyle == PresentationVerseNumberStyle.normal) {
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
            fontSize: 2.2,
            fontWeight: FontWeight.bold,
            color: paneTheme.accentColor,
          ),
        ),
      ),
    );
  }
}
