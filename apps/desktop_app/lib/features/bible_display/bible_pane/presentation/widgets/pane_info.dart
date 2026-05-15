import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/features/text_scaler/presentation/state/text_scaler_cubit.dart';
import 'package:open_scripture/shared/entities/bible_meta.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/widgets/active_pane_indicator.dart';

import '../../../../../shared/theme/tokens.dart';

class _PaneInfoItem extends StatelessWidget {
  const _PaneInfoItem({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8), child: child);
  }
}

class _PaneInfoLabel extends StatelessWidget {
  const _PaneInfoLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
            fontWeight: FontWeight.w400));
  }
}

class PaneInfo extends StatefulWidget {
  const PaneInfo({super.key});

  @override
  State<PaneInfo> createState() => _PaneInfoState();
}

class _PaneInfoState extends State<PaneInfo> {
  bool isExpanded = false;

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
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 12,
      ),
      child: Row(
        spacing: 2,
        children: [
          InkWell(
            hoverColor: Theme.of(context).colorScheme.primary,
            splashFactory: NoSplash.splashFactory,
            mouseCursor: SystemMouseCursors.click,
            onTap: () => setState(() {
              isExpanded = !isExpanded;
            }),
            child: Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xs),
                  // topRight: Radius.circular(AppRadius.xs),
                ),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Icon(
                isExpanded
                    ? Icons.keyboard_double_arrow_right_rounded
                    : Icons.keyboard_double_arrow_left_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                // topLeft: Radius.circular(AppRadius.xs),
                topRight: Radius.circular(AppRadius.xs),
              ),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Row(
              children: [
                if (isExpanded) const _PaneInfoLabel('zoom:'),
                BlocBuilder<TextScalerCubit, TextScalerState>(
                  builder: (context, state) {
                    return _PaneInfoItem(
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
                      ),
                    );
                  },
                ),
                BlocBuilder<BiblePaneBloc, BiblePaneState>(
                  builder: (context, state) {
                    return Row(mainAxisSize: MainAxisSize.min, children: [
                      if (isExpanded) const _PaneInfoLabel('display mode:'),
                      _PaneInfoItem(child: Text(state.dMode.name)),
                      if (isExpanded)
                        const _PaneInfoLabel('verse count displayed:'),
                      _PaneInfoItem(child: Text('${state.verseCount ?? '?'}')),
                    ]);
                  },
                ),
                if (enableStrongWords) ...[
                  if (isExpanded) const _PaneInfoLabel('strong word selected:'),
                  BlocBuilder<SelectedWordCubit, WordInfo?>(
                    builder: (context, wordInfo) {
                      return wordInfo == null
                          ? const SizedBox()
                          : _PaneInfoItem(
                              child: Text(
                                  '${wordInfo.text} ~ ${wordInfo.span.payload}'));
                    },
                  ),
                ],
                if (isExpanded) const _PaneInfoLabel('open bible:'),
                BlocSelector<BiblePaneBloc, BiblePaneState, List<BibleMeta>>(
                  selector: (state) =>
                      state.content.asMap.values.map((v) => v.meta).toList(),
                  builder: (context, metas) {
                    late final String text;
                    if (metas.isEmpty) text = '...';
                    if (metas.length > 1) {
                      text = metas.map((m) => m.abbreviation).join('  |  ');
                    }
                    if (metas.length == 1) text = metas.first.abbreviation;
                    return _PaneInfoItem(child: Text(text));
                  },
                ),
                if (pl > 1) ActivePaneIndicator(id: paneId)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
