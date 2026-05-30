import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/rendering/verse_richtext_builder.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';
import 'package:open_scripture/features/customizer/presentation/models/bible_pane_general_theme.dart';
import 'package:open_scripture/features/customizer/presentation/models/bible_view_list_theme.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/shared/domain/entities/verse.dart';

class VerseWidget extends StatelessWidget {
  final Verse verse;
  final bool isHighlighted;

  const VerseWidget({
    required this.verse,
    this.isHighlighted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final verseNumber = verse.ref.verseStart!;

    final useCustom = context.select(
      (CustomizerCubit c) => c.state.pane.enableCustomTheme,
    );
    final bTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
    final listTheme = Theme.of(context).extension<BibleViewListTheme>()!;

    final refStyle = TextStyle(
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

    final headingStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: bTheme.refColor,
      height: 2.0,
    );

    return Listener(
      onPointerDown: (_) {
        context.read<BiblePaneBloc>().add(
              BiblePaneJustChangeRef(
                  ref: verse.ref.copyWith(verseEnd: () => null)),
            );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SelectableText.rich(
              TextSpan(
                style: TextStyle(
                  height: 1.25,
                  fontWeight: bTheme.textFontWeight,
                ),
                children: [
                  // --- Verse reference number ---
                  TextSpan(
                    text: isHighlighted || listTheme.showFullRefAlways
                        ? verse.ref.toString()
                        : '$verseNumber',
                    style: refStyle,
                  ),
                  const TextSpan(text: '  '),

                  // --- Segments → spans ---
                  ..._buildSegmentSpans(context, headingStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<InlineSpan> _buildSegmentSpans(
    BuildContext context,
    TextStyle headingStyle,
  ) {
    final result = <InlineSpan>[];

    for (var i = 0; i < verse.segments.length; i++) {
      final segment = verse.segments[i];

      // Paragraph break — only insert if not the very first segment
      if (segment.isParagraphStart && i > 0) {
        result.add(const TextSpan(text: '\n'));
      }

      // Section heading above this segment
      if (segment.heading != null) {
        result.add(TextSpan(
          text: '${segment.heading}\n',
          style: headingStyle,
        ));
      }

      // The actual spans
      result.addAll(
        VerseSpanBuilder.build(
          spans: segment.spans,
          context: context,
          onWordTap: (VerseSpan span) =>
              context.read<SelectedWordCubit>().setSelectedWord(
                    WordInfo(span: span, text: span.text),
                  ),
        ),
      );
    }

    return result;
  }
}
