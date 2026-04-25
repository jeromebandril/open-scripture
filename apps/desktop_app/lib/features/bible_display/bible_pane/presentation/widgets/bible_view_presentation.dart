import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/entities/book_names.dart';
import '../../../../../shared/entities/verse_span.dart';
import '../../../../../injection_container.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../../customizer/presentation/models/bible_view_presentation_theme.dart';
import '../../../multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../state/bible_pane_bloc.dart';
import '../rendering/verse_richtext_builder.dart';

class BibleViewPresentation extends StatelessWidget {
  const BibleViewPresentation({super.key, required this.uniqueId});

  final int uniqueId;

  @override
  Widget build(BuildContext context) {
    final resolver = sl<BibleRefResolver>();
    // This is the ordered list for that versification/canon

    // Set padding
    final screen = MediaQuery.of(context).size;
    final panes = context.read<MultiPaneManagerCubit>().state.panes;
    final thisPaneIndex = panes.indexWhere((e) => e.id == uniqueId);

    // theming
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
    final presentTheme =
        Theme.of(context).extension<BibleViewPresentationTheme>()!;

    return BlocBuilder<BiblePaneBloc, BiblePaneState>(
      //
      // Rebuilds only when selected ref or content change
      //
      buildWhen: (prev, curr) =>
          prev.reference != curr.reference || prev.content != curr.content,
      builder: (context, state) {
        if (state.reference == null) return SizedBox();
        final ref = state.reference!;

        return Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Padding(
              //
              // Some padding that comes from global customization settings
              //
              padding: EdgeInsets.only(
                left:
                    thisPaneIndex == 0 ? screen.width * paneTheme.xPadding : 0,
                right: thisPaneIndex == panes.length - 1
                    ? screen.width * paneTheme.xPadding
                    : 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 32,
                children: [
                  //
                  // Full reference title
                  //
                  Builder(builder: (context) {
                    final fullNameBook =
                        resolver.resolveBook(ref.bookUsfxId)?.fullName;
                    return Text(
                      fullNameBook == null
                          ? ref.toString()
                          : ref.toString().replaceFirst(
                                ref.bookUsfxId,
                                fullNameBook,
                              ),
                      style: TextStyle(
                        fontWeight: paneTheme.selectedRefFontWeight,
                        fontFamily: paneTheme.referenceFont,
                        color: paneTheme.accentColor,
                        fontSize: 16,
                      ),
                    );
                  }),
                  //
                  // Build content here
                  //
                  Builder(builder: (context) {
                    final rangeToDisplay = state.content.getRefsInRange(ref);

                    // for each bible translation
                    final views = state.parallelOrder
                        .where((id) =>
                            state.content
                                .getParallelDataByBibleId(id)
                                ?.verses !=
                            null)
                        .map((id) {
                      final value = state.content.getParallelDataByBibleId(id)!;
                      final List<InlineSpan> verseInlineSpan = [];
                      final verses = value.verses!.entries
                          .where((e) => rangeToDisplay.contains(e.key))
                          .toList();

                      // compose the full verse from segments
                      // by joining the text content
                      // and grouping the spans into one List
                      for (final v in verses) {
                        final spans =
                            v.value.segments.expand((s) => s.spans).toList();
                        verseInlineSpan.add(VerseSpanBuilder.build(
                          context: context,
                          text: v.value.text,
                          spans: spans,
                          onWordTap: (VerseSpan span, String slice) {},
                        ));
                      }

                      // add verse number before each verse
                      List<InlineSpan> build() {
                        return [
                          for (int i = 0; i < rangeToDisplay.length; i++) ...[
                            TextSpan(text: '   '),
                            TextSpan(
                              text: '${rangeToDisplay[i].verseStart!}',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: paneTheme.accentColor,
                                  decoration: TextDecoration.underline),
                            ),
                            TextSpan(text: ' '),
                            verseInlineSpan[i],
                          ],
                        ];
                      }

                      return MapEntry(
                          '${value.meta.bibleName} - ${value.meta.langNativeName}',
                          Text.rich(
                            TextSpan(
                                style: TextStyle(
                                    fontWeight: paneTheme.textFontWeight),
                                children: rangeToDisplay.length > 1
                                    ? build()
                                    : verseInlineSpan),
                            textAlign: presentTheme.textAlignment,
                          ));
                    }).toList();

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 64,
                      children: views
                          .map(
                            (e) => Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (views.length != 1)
                                  Text(
                                    '(${e.key})',
                                    style: TextStyle(
                                        color: paneTheme.enableCustomTheme
                                            ? paneTheme.refColor
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                        fontWeight:
                                            presentTheme.subtitleFontWeight,
                                        fontSize: 8),
                                  ),
                                e.value,
                              ],
                            ),
                          )
                          .toList(),
                    );
                  })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
