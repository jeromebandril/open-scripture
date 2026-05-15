import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';

import '../../../../../shared/entities/bible_ref.dart';
import '../../../../../shared/entities/verse_segment.dart';
import '../../../../../shared/entities/verse_span.dart';
import '../../../../customizer/presentation/state/customizer_cubit.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../../customizer/presentation/models/bible_view_list_theme.dart';
import '../rendering/verse_richtext_builder.dart';

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

    return Listener(
      onPointerDown: (_) {
        context.read<BiblePaneBloc>().add(
            BiblePaneJustChangeRef(ref: reference.copyWith(verseEnd: null)));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SelectableText.rich(TextSpan(
                style: TextStyle(
                  height: 1.25,
                  fontWeight: bTheme.textFontWeight,
                ),
                children: [
                  TextSpan(
                    text: isHighlighted || listTheme.showFullRefAlways
                        ? reference.toString()
                        : '$verseNumber',
                    style: refStyle,
                  ),
                  TextSpan(text: '  '),
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
