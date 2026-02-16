import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/text_scaler/cubit/text_scaler_cubit.dart';
import 'package:open_scripture/shared/presentation/widgets/hoverable_container.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';
import 'package:open_scripture/features/bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import 'package:open_scripture/features/bible_display/split_screen/presenter/widgets/parts/active_pane_indicator.dart';

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
              BlocBuilder<TextScalerCubit, TextScalerState>(
                builder: (context, state) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.zoom_in,
                            size: 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          Text('${state.textScaleFactor.toStringAsFixed(2)}x'),
                        ],
                      ));
                },
              ),
              BlocSelector<BiblePaneBloc, BiblePaneState, int?>(
                  selector: (s) => s.maxVerse,
                  builder: (ctx, maxV) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text('max vv. ${maxV ?? '?'}'));
                  }),
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
