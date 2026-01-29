import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/core/presentation/widgets/hoverable_container.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/presenter/widgets/parts/active_pane_indicator.dart';

class PaneInfo extends StatefulWidget {
  const PaneInfo({super.key});

  @override
  State<PaneInfo> createState() => _PaneInfoState();
}

class _PaneInfoState extends State<PaneInfo> {
  bool isExpanded = false;
  final _tooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    final bibleMeta = context.select((BiblePaneBloc b) => b.state.bibleMeta);
    final pl = context.select((PaneManagerCubit b) => b.state.panes.length);
    final paneId = context.select((BiblePaneBloc b) => b.state.paneId);

    return DefaultTextStyle(
      style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface, fontSize: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 24,
          child: Row(
            children: [
              // SELECTED WORD
              BlocBuilder<SelectedWordCubit, WordInfo?>(
                builder: (context, wordInfo) {
                  return wordInfo == null
                      ? const SizedBox()
                      : HoverableContainer(
                          hoveredColor:
                              Theme.of(context).colorScheme.surfaceDim,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Tooltip(
                            waitDuration: const Duration(days: 1),
                            key: _tooltipKey,
                            message: 'copied to clipboard !',
                            triggerMode: TooltipTriggerMode.manual,
                            showDuration: const Duration(seconds: 2),
                            exitDuration: const Duration(seconds: 2),
                            ignorePointer: true,
                            enableTapToDismiss: false,
                            child: InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: wordInfo.span.payload ?? ''));
                                _tooltipKey.currentState
                                    ?.ensureTooltipVisible();
                              },
                              child: Text(
                                  '${wordInfo.text} ~ ${wordInfo.span.payload}'),
                            ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    bibleMeta == null
                        ? 'Unknown'
                        : isExpanded
                            ? '${bibleMeta.usfxId} — ${bibleMeta.bibleNameLocal} — ${bibleMeta.langEngName}'
                            : bibleMeta.abbreviation,
                  ),
                ),
              ),
              if (pl > 1) ActivePaneIndicator(id: paneId)
            ],
          ),
        ),
      ),
    );
  }
}
