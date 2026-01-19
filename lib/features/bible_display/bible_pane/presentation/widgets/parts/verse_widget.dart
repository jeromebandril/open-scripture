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
    final BibleRef ref = segments.first.ref;

    final useCustom = context.select(
      (CustomizerCubit c) => c.state.pane.enableCustomTheme,
    );
    final biblePaneTheme = Theme.of(context).extension<BiblePaneTheme>()!;

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
          : SelectableText.rich(
              TextSpan(style: TextStyle(height: 1.2), children: [
              TextSpan(
                text: isHighlighted || biblePaneTheme.showFullRefAlways
                    ? '${ref.toString()}  '
                    : '$verseNumber  ',
                style: TextStyle(
                  fontWeight: isHighlighted
                      ? FontWeight.bold
                      : biblePaneTheme.showFullRefAlways
                          ? FontWeight.w500
                          : FontWeight.bold,
                  color: isHighlighted
                      ? biblePaneTheme.accentColor
                      : useCustom
                          ? biblePaneTheme.textColor
                          : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              VerseSpanBuilder.build(
                context: context,
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
