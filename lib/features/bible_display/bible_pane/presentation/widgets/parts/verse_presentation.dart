import 'package:flutter/material.dart';

import '../../../../../../core/domain/entities/bible_ref.dart';
import '../../../../../../core/domain/entities/verse_segment.dart';
import '../../../../../../core/domain/entities/verse_span.dart';
import '../../../../../../core/utils/bible_ref_parser/bible_ref_parser.dart';
import '../../../../../customizer/domain/entities/bible_pane_theme.dart';
import '../../rendering/verse_richtext_builder.dart';

class VersePresentation extends StatelessWidget {
  const VersePresentation({
    super.key,
    required this.verses,
    required this.ref,
    this.spans,
    this.padding = EdgeInsets.zero,
  });

  final List<List<VerseSegment>> verses;
  final List<List<VerseSpan>>? spans;
  final BibleRef ref;
  final EdgeInsets padding;

  static final Map<String, String> charCodeToBibleBookName =
      BibleReferenceParser.bibleBookNameTo3CharCode.map(
    (key, value) => MapEntry(value.toUpperCase(), key),
  );

  @override
  Widget build(BuildContext context) {
    final biblePaneTheme = Theme.of(context).extension<BiblePaneTheme>()!;

    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ref.toString().replaceFirst(ref.bookOsisId,
                  charCodeToBibleBookName[ref.bookOsisId] ?? 'error'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: biblePaneTheme.referenceFont,
                color: biblePaneTheme.accentColor,
              ),
            ),
            Builder(builder: (context) {
              List<InlineSpan> inlineSpans = [];
              for (int i = 0; i < verses.length; i++) {
                String content = verses[i].map((e) => e.textContent).join();

                inlineSpans.add(VerseSpanBuilder.build(
                  context: context,
                  text: content,
                  spans: spans![i],
                  onWordTap: (VerseSpan span, String slice) {},
                ));
              }
              // add verse number before each verse
              List<InlineSpan> build() {
                return [
                  for (int i = 0; i < verses.length; i++) ...[
                    TextSpan(
                      text: '   ${i + ref.verseStart!} ',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: biblePaneTheme.accentColor,
                      ),
                    ),
                    inlineSpans[i],
                  ],
                ];
              }

              return Text.rich(TextSpan(
                  style: TextStyle(
                    fontWeight: biblePaneTheme.textFontWeight,
                  ),
                  children: build()));
            })
          ],
        ),
      ),
    );
  }
}
