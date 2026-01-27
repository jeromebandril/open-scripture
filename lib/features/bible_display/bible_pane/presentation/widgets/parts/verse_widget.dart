import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';

import '../../../../../../core/domain/entities/bible_ref.dart';
import '../../../../../../core/domain/entities/verse_segment.dart';
import '../../../../../../core/domain/entities/verse_span.dart';
import '../../../../../customizer/domain/entities/bible_pane_theme.dart';
import '../../../../../customizer/presentation/cubit/customizer_cubit.dart';
import '../../rendering/verse_richtext_builder.dart';

enum HighlightRenderMode {
  fullRefWithColor;
}

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
    final biblePaneTheme = Theme.of(context).extension<BiblePaneTheme>()!;

    final refStyle = TextStyle(
      height: 1.25,
      fontFamily: biblePaneTheme.referenceFont,
      fontWeight: isHighlighted
          ? FontWeight.w800
          : biblePaneTheme.showFullRefAlways
              ? FontWeight.w500
              : FontWeight.bold,
      color: isHighlighted
          ? biblePaneTheme.accentColor
          : useCustom
              ? biblePaneTheme.refColor
              : Theme.of(context).colorScheme.onSurface,
    );

    return Listener(
      onPointerDown: (_) {
        final ref = context.read<BiblePaneBloc>().state.reference!;
        context.read<BiblePaneBloc>().add(BiblePaneJustChangeRef(
                ref: ref.copyWith(
              bookOsisId: reference.bookOsisId,
              chapter: reference.chapter,
              verseStart: reference.verseStart,
              verseEnd: null,
            )));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (biblePaneTheme.enableHangingRefs)
            Text(
              '${reference.toString().padLeft(3, ' ')}   ',
              style: refStyle,
            ),
          Expanded(
            child: SelectableText.rich(TextSpan(
                style: TextStyle(
                  height: 1.25,
                  fontWeight: biblePaneTheme.textFontWeight,
                ),
                children: [
                  if (!biblePaneTheme.enableHangingRefs)
                    TextSpan(
                      text: isHighlighted || biblePaneTheme.showFullRefAlways
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
