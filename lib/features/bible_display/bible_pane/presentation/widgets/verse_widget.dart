import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';

import '../../../../../core/domain/entities/verse_segment.dart';
import '../../../../../core/domain/entities/verse_span.dart';
import '../rendering/verse_richtext_builder.dart';

class VerseWidget extends StatelessWidget {
  final int verseNumber;
  final List<VerseSegment> segments;
  final List<VerseSpan>? spans;

  const VerseWidget({
    required this.verseNumber,
    required this.segments,
    this.spans,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String content = segments.map((e) => e.textContent).join();

    return Stack(
      children: [
        spans == null
            ? Text(content)
            : SelectableText.rich(TextSpan(children: [
                TextSpan(
                    text: '$verseNumber  ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                VerseSpanBuilder.build(
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
      ],
    );
  }
}
