import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/features/text_scaler/presentation/state/text_scaler_cubit.dart';
import 'package:open_scripture/shared/entities/bible_meta.dart';
import 'package:open_scripture/shared/widgets/hoverable_container.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/widgets/active_pane_indicator.dart';

import '../../../../../../shared/theme/tokens.dart';

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
    final pl =
        context.select((MultiPaneManagerCubit b) => b.state.panes.length);
    final paneId = context.select((BiblePaneBloc b) => b.state.paneId);
    final enableStrongWords = context.select(
      (CustomizerCubit c) => c.state.pane.underlineStrongWords,
    );

    return DefaultTextStyle(
      style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface, fontSize: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadius.xs),
              topRight: Radius.circular(AppRadius.xs),
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
                  selector: (s) => s.verseCount,
                  builder: (ctx, vCount) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text('v. count ${vCount ?? '?'}'));
                  }),
              // SELECTED WORD
              if (enableStrongWords)
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
                  child: BlocSelector<BiblePaneBloc, BiblePaneState,
                      List<BibleMeta>>(
                    selector: (state) =>
                        state.content.asMap.values.map((v) => v.meta).toList(),
                    builder: (context, metas) {
                      late final String text;
                      if (metas.isEmpty) text = '...';
                      if (metas.length > 1) {
                        text = metas.map((m) => m.abbreviation).join('  |  ');
                      }
                      if (metas.length == 1) {
                        text = isExpanded
                            ? '${metas.first.extId} — ${metas.first.bibleNameLocal} — ${metas.first.langEngName}'
                            : metas.first.abbreviation;
                      }
                      return Text(text);
                    },
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
