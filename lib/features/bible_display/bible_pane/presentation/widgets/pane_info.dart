import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:the_smyrna_bible_v2/core/presentation/widgets/hoverable_container.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';

class PaneInfo extends StatefulWidget {
  const PaneInfo({super.key});

  @override
  State<PaneInfo> createState() => _PaneInfoState();
}

class _PaneInfoState extends State<PaneInfo> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bibleMeta = context.select(
      (BiblePaneBloc b) => b.state.bibleMeta, // ideally Set<String>s
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        margin: EdgeInsets.all(4),
        height: 25,
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          spacing: 28,
          children: [
            // SELECTED WORD
            BlocBuilder<SelectedWordCubit, WordInfo?>(
              builder: (context, wordInfo) {
                return wordInfo == null
                    ? SizedBox()
                    : HoverableContainer(
                        hoveredColor: Theme.of(context).colorScheme.surfaceDim,
                        child: GestureDetector(
                          onTap: () => print(wordInfo.span.payload),
                          child: Text(
                              '${wordInfo.text} ~ ${wordInfo.span.payload}'),
                        ),
                      );
              },
            ),

            // BIBLE METADATA
            GestureDetector(
              onTap: () => setState(() {
                isExpanded = !isExpanded;
              }),
              child: HoverableContainer(
                hoveredColor: Theme.of(context).colorScheme.surfaceDim,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  bibleMeta == null
                      ? 'Unknown'
                      : isExpanded
                          ? '${bibleMeta.extId} — ${bibleMeta.bibleName} — ${bibleMeta.langEngName}'
                          : bibleMeta.abbreviation,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
