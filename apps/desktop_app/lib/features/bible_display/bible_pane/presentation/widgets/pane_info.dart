import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/domain/entities/bible_translation.dart';
import '../../../../customizer/presentation/state/customizer_cubit.dart';
import '../../../../text_scaler/presentation/state/text_scaler_cubit.dart';
import '../../../multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../../multi_pane_manager/presentation/widgets/active_pane_indicator.dart';
import '../cubit/selected_word_cubit.dart';
import '../state/bible_pane_bloc.dart';

class _PaneInfoItem extends StatelessWidget {
  const _PaneInfoItem({required this.child, this.tooltip});

  final Widget child;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8), child: child),
    );
  }
}

class PaneInfo extends StatefulWidget {
  const PaneInfo({super.key});

  @override
  State<PaneInfo> createState() => _PaneInfoState();
}

class _PaneInfoState extends State<PaneInfo> {
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
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 12,
      ),
      child: Container(
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xs),
            topRight: Radius.circular(AppRadius.xs),
          ),
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withAlpha(240),
        ),
        child: Row(
          children: [
            BlocBuilder<TextScalerCubit, TextScalerState>(
              builder: (context, state) {
                return _PaneInfoItem(
                  tooltip: 'Zoom level',
                  child: Row(
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.zoom_in,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      Text('${state.textScaleFactor.toStringAsFixed(2)}x'),
                    ],
                  ),
                );
              },
            ),
            BlocBuilder<BiblePaneBloc, BiblePaneState>(
              builder: (context, state) {
                return _PaneInfoItem(
                    tooltip: 'Verse count',
                    child: Row(
                      spacing: 2,
                      children: [
                        Icon(
                          Icons.numbers_rounded,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        Text('${state.verseCount ?? '?'}'),
                      ],
                    ));
              },
            ),
            if (enableStrongWords)
              BlocBuilder<SelectedWordCubit, WordInfo?>(
                builder: (context, wordInfo) {
                  return wordInfo == null
                      ? const SizedBox()
                      : _PaneInfoItem(
                          child: Text(
                              '${wordInfo.text} ~ ${wordInfo.span.payload}'));
                },
              ),
            BlocSelector<BiblePaneBloc, BiblePaneState, List<BibleTranslation>>(
              selector: (state) =>
                  state.content.asMap.values.map((v) => v.meta).toList(),
              builder: (context, metas) {
                late final String text;
                if (metas.isEmpty) text = '...';
                if (metas.length > 1) {
                  text = metas.map((m) => m.abbreviation).join('  |  ');
                }
                if (metas.length == 1) text = metas.first.abbreviation;
                return _PaneInfoItem(
                    tooltip: 'Open bibles',
                    child: Row(
                      spacing: 4,
                      children: [
                        Icon(
                          Icons.book_rounded,
                          size: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        Text(text),
                      ],
                    ));
              },
            ),
            if (pl > 1) ActivePaneIndicator(id: paneId)
          ],
        ),
      ),
    );
  }
}
