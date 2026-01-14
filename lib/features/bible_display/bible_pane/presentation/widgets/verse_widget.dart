import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';

import '../../../../../core/domain/entities/verse_segment.dart';
import '../../../../../core/domain/entities/verse_span.dart';
import '../rendering/verse_richtext_builder.dart';

class VerseWidget extends StatelessWidget {
  final int verseNumber;
  final List<VerseSegment> segments;
  final List<VerseSpan>? spans;
  final bool isHighlighted;

  const VerseWidget({
    required this.verseNumber,
    required this.segments,
    this.spans,
    this.isHighlighted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String content = segments.map((e) => e.textContent).join();

    return Listener(
      onPointerDown: (_) {
        final ref = context.read<BiblePaneBloc>().state.reference!;
        context.read<BiblePaneBloc>().add(BiblePaneJustChangeRef(
                ref: ref.copyWith(
              verseStart: verseNumber,
              verseEnd: null,
            )));
      },
      child: spans == null
          ? Text(content)
          : SelectableText.rich(TextSpan(children: [
              TextSpan(
                text: '$verseNumber  ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isHighlighted
                        ? Colors.cyan
                        : Theme.of(context).colorScheme.onSurface),
              ),
              VerseSpanBuilder.build(
                text: content,
                spans: spans!,
                onWordTap: (VerseSpan span, String slice) =>
                    context.read<SelectedWordCubit>().setSelectedWord(WordInfo(
                          text: slice,
                          span: span,
                        )),
              ),
            ])),
    );
  }
}
