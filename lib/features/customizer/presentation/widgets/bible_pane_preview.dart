import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_segment.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_span.dart';

import '../../../../core/domain/entities/bible_ref.dart';
import '../../../bible_display/bible_pane/presentation/rendering/verse_richtext_builder.dart';
import '../../../bible_display/bible_pane/presentation/widgets/parts/verse_divider.dart';
import '../cubit/customizer_cubit.dart';
import '../models/bible_pane_general_theme.dart';

typedef PreviewData = ({
  int verseNumber,
  List<VerseSegment> segments,
  List<VerseSpan> spans,
});

const List<PreviewData> previewData = [
  (
    verseNumber: 37,
    segments: [
      VerseSegment(
        bibleId: 1,
        ref: BibleRef(
            bookUsfxId: 'JHN', chapter: 7, verseStart: 37, verseEnd: null),
        segmentIndex: 0,
        paragraphStart: false,
        textContent:
            'In the last day, that great day of the feast, Jesus stood and cried, saying, '
            'If any man thirst, let him come unto me, and drink.',
        subtitle: null,
        spans: [],
      ),
    ],
    spans: [
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 0,
          endOffset: 2,
          type: SpanType.strongWords,
          payload: 'G1722'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 7,
          endOffset: 11,
          type: SpanType.strongWords,
          payload: 'G2078'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 12,
          endOffset: 15,
          type: SpanType.strongWords,
          payload: 'G2250'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 17,
          endOffset: 21,
          type: SpanType.strongWords,
          payload: 'G3588'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 22,
          endOffset: 27,
          type: SpanType.strongWords,
          payload: 'G3173'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 28,
          endOffset: 31,
          type: SpanType.italic,
          payload: null),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 39,
          endOffset: 44,
          type: SpanType.strongWords,
          payload: 'G1859'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 46,
          endOffset: 51,
          type: SpanType.strongWords,
          payload: 'G2424'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 52,
          endOffset: 57,
          type: SpanType.strongWords,
          payload: 'G2476'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 58,
          endOffset: 61,
          type: SpanType.strongWords,
          payload: 'G2532'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 62,
          endOffset: 67,
          type: SpanType.strongWords,
          payload: 'G2896'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 69,
          endOffset: 75,
          type: SpanType.strongWords,
          payload: 'G3004'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 77,
          endOffset: 79,
          type: SpanType.strongWords,
          payload: 'G1437'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 77,
          endOffset: 128,
          type: SpanType.wordOfJesus,
          payload: null),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 80,
          endOffset: 87,
          type: SpanType.strongWords,
          payload: 'G5100'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 88,
          endOffset: 94,
          type: SpanType.strongWords,
          payload: 'G1372'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 96,
          endOffset: 108,
          type: SpanType.strongWords,
          payload: 'G2064'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 109,
          endOffset: 113,
          type: SpanType.strongWords,
          payload: 'G4314'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 114,
          endOffset: 116,
          type: SpanType.strongWords,
          payload: 'G3165'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 118,
          endOffset: 121,
          type: SpanType.strongWords,
          payload: 'G2532'),
      VerseSpan(
          verseSegmentId: 26366,
          startOffset: 122,
          endOffset: 127,
          type: SpanType.strongWords,
          payload: 'G4095'),
    ],
  ),
  (
    verseNumber: 38,
    segments: [
      VerseSegment(
        bibleId: 1,
        ref: BibleRef(
            bookUsfxId: 'JHN', chapter: 7, verseStart: 38, verseEnd: null),
        segmentIndex: 0,
        paragraphStart: false,
        textContent:
            'He that believeth on me, as the scripture hath said, out of his belly shall flow '
            'rivers of living water.',
        subtitle: null,
        spans: [],
      ),
    ],
    spans: [
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 0,
          endOffset: 17,
          type: SpanType.strongWords,
          payload: 'G4100'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 0,
          endOffset: 104,
          type: SpanType.wordOfJesus,
          payload: null),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 18,
          endOffset: 20,
          type: SpanType.strongWords,
          payload: 'G1519'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 21,
          endOffset: 23,
          type: SpanType.strongWords,
          payload: 'G1691'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 25,
          endOffset: 27,
          type: SpanType.strongWords,
          payload: 'G2531'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 28,
          endOffset: 41,
          type: SpanType.strongWords,
          payload: 'G1124'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 42,
          endOffset: 51,
          type: SpanType.strongWords,
          payload: 'G2036'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 53,
          endOffset: 59,
          type: SpanType.strongWords,
          payload: 'G1537'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 60,
          endOffset: 63,
          type: SpanType.strongWords,
          payload: 'G0846'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 64,
          endOffset: 69,
          type: SpanType.strongWords,
          payload: 'G2836'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 70,
          endOffset: 80,
          type: SpanType.strongWords,
          payload: 'G4482'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 81,
          endOffset: 87,
          type: SpanType.strongWords,
          payload: 'G4215'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 88,
          endOffset: 90,
          type: SpanType.strongWords,
          payload: 'G5204'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 91,
          endOffset: 97,
          type: SpanType.strongWords,
          payload: 'G2198'),
      VerseSpan(
          verseSegmentId: 26367,
          startOffset: 98,
          endOffset: 103,
          type: SpanType.strongWords,
          payload: 'G5204'),
    ],
  ),
  (
    verseNumber: 39,
    segments: [
      VerseSegment(
        bibleId: 1,
        ref: BibleRef(
            bookUsfxId: 'JHN', chapter: 7, verseStart: 39, verseEnd: null),
        segmentIndex: 0,
        paragraphStart: false,
        textContent:
            '(But this spake he of the Spirit, which they that believe on him should receive: '
            'for the Holy Ghost was not yet given; because that Jesus was not yet glorified.)',
        subtitle: null,
        spans: [],
      ),
    ],
    spans: [
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 1,
          endOffset: 4,
          type: SpanType.strongWords,
          payload: 'G1161'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 5,
          endOffset: 9,
          type: SpanType.strongWords,
          payload: 'G5124'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 16,
          endOffset: 18,
          type: SpanType.strongWords,
          payload: 'G2036'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 19,
          endOffset: 21,
          type: SpanType.strongWords,
          payload: 'G4012'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 26,
          endOffset: 32,
          type: SpanType.strongWords,
          payload: 'G4151'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 34,
          endOffset: 39,
          type: SpanType.strongWords,
          payload: 'G3739'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 50,
          endOffset: 57,
          type: SpanType.strongWords,
          payload: 'G4100'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 58,
          endOffset: 60,
          type: SpanType.strongWords,
          payload: 'G1519'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 61,
          endOffset: 64,
          type: SpanType.strongWords,
          payload: 'G0846'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 65,
          endOffset: 71,
          type: SpanType.strongWords,
          payload: 'G3195'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 72,
          endOffset: 79,
          type: SpanType.strongWords,
          payload: 'G2983'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 81,
          endOffset: 84,
          type: SpanType.strongWords,
          payload: 'G1063'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 85,
          endOffset: 88,
          type: SpanType.strongWords,
          payload: 'G4151'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 89,
          endOffset: 93,
          type: SpanType.strongWords,
          payload: 'G0040'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 94,
          endOffset: 99,
          type: SpanType.strongWords,
          payload: 'G4151'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 100,
          endOffset: 103,
          type: SpanType.strongWords,
          payload: 'G2258'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 108,
          endOffset: 111,
          type: SpanType.strongWords,
          payload: 'G3768'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 112,
          endOffset: 117,
          type: SpanType.italic,
          payload: null),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 127,
          endOffset: 131,
          type: SpanType.strongWords,
          payload: 'G3754'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 132,
          endOffset: 137,
          type: SpanType.strongWords,
          payload: 'G2424'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 138,
          endOffset: 141,
          type: SpanType.strongWords,
          payload: 'G1392'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 146,
          endOffset: 149,
          type: SpanType.strongWords,
          payload: 'G3764'),
      VerseSpan(
          verseSegmentId: 26368,
          startOffset: 150,
          endOffset: 159,
          type: SpanType.strongWords,
          payload: 'G1392'),
    ],
  ),
];

class BiblePanePreview extends StatelessWidget {
  const BiblePanePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final useCustom = context.select(
      (CustomizerCubit c) => c.state.pane.enableCustomTheme,
    );
    final biblePaneTheme =
        Theme.of(context).extension<BiblePaneGeneralTheme>()!;

    return Column(
      spacing: 4,
      children: [
        // Text(
        //   'Preview',
        //   style: TextStyle(fontWeight: FontWeight.w100, fontSize: 12),
        // ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: !useCustom || biblePaneTheme.enableHangingRefs
                ? Theme.of(context).colorScheme.surface
                : biblePaneTheme.backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (biblePaneTheme.enableHangingRefs)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'John 7',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: biblePaneTheme.referenceFont,
                      //color: paneTheme.accentColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: useCustom
                      ? biblePaneTheme.backgroundColor
                      : Theme.of(context).colorScheme.surface,
                ),
                padding: EdgeInsets.all(8),
                child: DefaultTextStyle.merge(
                  style: TextStyle(fontFamily: biblePaneTheme.textFont),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: previewData.length,
                    itemBuilder: (_, i) {
                      return _VerseWidgetPreview(
                        verseNumber: previewData[i].verseNumber,
                        segments: previewData[i].segments,
                        spans: previewData[i].spans,
                        isHighlighted: i == 0,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return VerseDivider();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerseWidgetPreview extends StatelessWidget {
  final int verseNumber;
  final List<VerseSegment> segments;
  final List<VerseSpan>? spans;
  final bool isHighlighted;

  const _VerseWidgetPreview({
    required this.verseNumber,
    required this.segments,
    this.spans,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final String content = segments.map((e) => e.textContent).join();
    final BibleRef ref = segments.first.ref;

    final useCustom = context.select(
      (CustomizerCubit c) => c.state.pane.enableCustomTheme,
    );
    final bTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;

    final refStyle = TextStyle(
      height: 1.25,
      fontFamily: bTheme.referenceFont,
      fontWeight:
          isHighlighted ? bTheme.selectedRefFontWeight : bTheme.refFontWeight,
      color: isHighlighted
          ? bTheme.accentColor
          : useCustom
              ? bTheme.refColor
              : Theme.of(context).colorScheme.onSurface,
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: 8,
        left: bTheme.widthAdjustmentOffset / 5 + bTheme.xPadding / 5,
        right: bTheme.widthAdjustmentOffset / 5 + bTheme.xPadding / 5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bTheme.enableHangingRefs)
            Text(
              '${verseNumber.toString().padLeft(3, ' ')}   ',
              style: refStyle,
            ),
          Expanded(
            child: SelectableText.rich(TextSpan(
                style: TextStyle(
                  height: 1.2,
                  fontWeight: bTheme.textFontWeight,
                  color: useCustom
                      ? bTheme.textColor
                      : Theme.of(context).colorScheme.onSurface,
                ),
                children: [
                  if (!bTheme.enableHangingRefs)
                    TextSpan(
                      text: isHighlighted || bTheme.showFullRefAlways
                          ? '${ref.toString()}  '
                          : '$verseNumber  ',
                      style: refStyle,
                    ),
                  VerseSpanBuilder.build(
                    context: context,
                    text: content,
                    spans: spans!,
                    onWordTap: (VerseSpan span, String slice) {},
                  ),
                ])),
          ),
        ],
      ),
    );
  }
}
