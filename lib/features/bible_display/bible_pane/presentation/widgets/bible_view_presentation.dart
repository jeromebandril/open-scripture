import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/domain/entities/book_names.dart';
import '../../../../../core/domain/entities/verse_segment.dart';
import '../../../../../core/domain/entities/verse_span.dart';
import '../../../../../injection_container.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../split_screen/presenter/cubit/pane_manager_cubit.dart';
import '../bloc/bible_pane_bloc.dart';
import '../rendering/verse_richtext_builder.dart';

class BibleViewPresentation extends StatelessWidget {
  const BibleViewPresentation({
    super.key,
    required this.uniqueId,
    required this.segments,
  });

  final int uniqueId;
  final List<VerseSegment> segments;

  @override
  Widget build(BuildContext context) {
    final resolver = sl<BibleRefResolver>();
    // This is the ordered list for that versification/canon

    // group segments by verse
    final segmentsByVerse = <int, List<VerseSegment>>{};
    for (final s in segments) {
      final key = s.ref.verseStart; // assuming int
      (segmentsByVerse[key!] ??= <VerseSegment>[]).add(s);
    }

    // Set padding
    final screen = MediaQuery.of(context).size;
    final panes = context.read<PaneManagerCubit>().state.panes;
    final thisPaneIndex = panes.indexWhere((e) => e.id == uniqueId);

    // theming
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;

    return BlocBuilder<BiblePaneBloc, BiblePaneState>(
      buildWhen: (prev, curr) => prev.reference != curr.reference,
      builder: (context, state) {
        final ref = state.reference!;
        // Set content
        final vn = state.reference?.verseStart ?? 1;
        final ve = state.reference?.verseEnd ?? vn;
        final List<List<VerseSegment>> verses = [];

        for (var i = vn; i <= ve; i++) {
          if (segmentsByVerse[i] != null) {
            verses.add(segmentsByVerse[i]!);
          }
        }

        final spans = verses
            .map(
              (v) => v.expand((s) => s.spans).toList(),
            )
            .toList();

        return Center(
          child: SingleChildScrollView(
            child: Padding(
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
                children: [
                  Text(
                    ref.toString().replaceFirst(
                          ref.bookUsfxId,
                          resolver.resolveBook(ref.bookUsfxId)?.fullName ??
                              'error',
                        ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: paneTheme.referenceFont,
                      color: paneTheme.accentColor,
                    ),
                  ),
                  Builder(builder: (context) {
                    List<InlineSpan> inlineSpans = [];
                    for (int i = 0; i < verses.length; i++) {
                      String content =
                          verses[i].map((e) => e.textContent).join();

                      inlineSpans.add(VerseSpanBuilder.build(
                        context: context,
                        text: content,
                        spans: spans[i],
                        onWordTap: (VerseSpan span, String slice) {},
                      ));
                    }
                    // add verse number before each verse
                    List<InlineSpan> build() {
                      return [
                        for (int i = 0; i < verses.length; i++) ...[
                          TextSpan(text: '   '),
                          TextSpan(
                            text: '${i + ref.verseStart!}',
                            style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: paneTheme.accentColor,
                                decoration: TextDecoration.underline),
                          ),
                          TextSpan(text: ' '),
                          inlineSpans[i],
                        ],
                      ];
                    }

                    return Text.rich(TextSpan(
                        style: TextStyle(
                          fontWeight: paneTheme.textFontWeight,
                        ),
                        children: build()));
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
