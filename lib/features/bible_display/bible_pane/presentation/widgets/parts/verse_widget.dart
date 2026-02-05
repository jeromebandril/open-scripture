import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';

import '../../../../../../core/domain/entities/bible_ref.dart';
import '../../../../../../core/domain/entities/verse_segment.dart';
import '../../../../../../core/domain/entities/verse_span.dart';
import '../../../../../customizer/presentation/cubit/customizer_cubit.dart';
import '../../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../rendering/verse_richtext_builder.dart';

class VerseWidget extends StatelessWidget {
  final BibleRef reference;
  final List<VerseSegment> segments;
  final List<VerseSpan>? spans;
  final bool isHighlighted;

  const VerseWidget({
    required this.reference,
    required this.segments,
    this.spans,
    this.isHighlighted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String content = segments.map((e) => e.textContent).join();
    final int verseNumber = reference.verseStart!;

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
              : Theme.of(context).colorScheme.secondary,
    );

    return Listener(
      onPointerDown: (_) {
        final ref = context.read<BiblePaneBloc>().state.reference!;
        context.read<BiblePaneBloc>().add(BiblePaneJustChangeRef(
                ref: ref.copyWith(
              bookOsisId: reference.bookUsfxId,
              chapter: reference.chapter,
              verseStart: reference.verseStart,
              verseEnd: null,
            )));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bTheme.enableHangingRefs)
            Text(
              '${reference.verseStart.toString().padLeft(3, ' ')}   ',
              style: refStyle,
            ),
          Expanded(
            child: SelectableText.rich(TextSpan(
                style: TextStyle(
                  height: 1.25,
                  fontWeight: bTheme.textFontWeight,
                ),
                children: [
                  if (!bTheme.enableHangingRefs)
                    TextSpan(
                      text: isHighlighted || bTheme.showFullRefAlways
                          ? '${reference.toString()}  '
                          : '$verseNumber  ',
                      style: refStyle,
                    ),
                  VerseSpanBuilder.build(
                    context: context,
                    text: content,
                    spans: spans!,
                    onWordTap: (VerseSpan span, String slice) => context
                        .read<SelectedWordCubit>()
                        .setSelectedWord(WordInfo(
                          text: slice,
                          span: span,
                        )),
                  ),
                ])),
          ),
        ],
      ),
    );
  }
}
