import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/domain/entities/bible_translation.dart';
import '../../../../text_scaler/presentation/state/text_scaler_cubit.dart';
import '../../../multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../../multi_pane_manager/presentation/widgets/active_pane_indicator.dart';
import '../../../settings/presentation/widgets/bible_view_settings_provider.dart';
import '../../domain/display_mode.dart';
import '../../domain/entities/word_info.dart';
import '../state/bible_pane_bloc.dart';

class _PaneInfoItem extends StatelessWidget {
  const _PaneInfoItem({
    required this.text,
    this.icon,
    this.tooltip,
  });

  final String text;
  final IconData? icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              Icon(icon,
                  size: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              Text(text),
            ],
          )),
    );
  }
}

class PaneInfo extends StatefulWidget {
  static const double kHeight = 24;
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
    final enableStrongWords =
        BibleViewSettingsScope.of(context).underlineStrongWords;

    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 12,
      ),
      child: Container(
        height: PaneInfo.kHeight,
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
                  icon: LucideIcons.zoomIn,
                  text: '${state.textScaleFactor.toStringAsFixed(2)}x',
                );
              },
            ),
            BlocSelector<BiblePaneBloc, BiblePaneState, DisplayMode>(
              selector: (state) => state.dMode,
              builder: (context, dMode) {
                return _PaneInfoItem(
                    tooltip: 'Display mode',
                    icon: LucideIcons.monitor,
                    text: dMode.name);
              },
            ),
            BlocSelector<BiblePaneBloc, BiblePaneState, int?>(
              selector: (state) => state.verseCount,
              builder: (context, verseCount) {
                return _PaneInfoItem(
                    tooltip: 'Verse count',
                    icon: LucideIcons.hash,
                    text: '${verseCount ?? '_'}');
              },
            ),
            if (enableStrongWords)
              BlocSelector<BiblePaneBloc, BiblePaneState, WordInfo?>(
                selector: (state) => state.selectedWord,
                builder: (context, wordInfo) {
                  return wordInfo == null
                      ? const SizedBox()
                      : _PaneInfoItem(
                          icon: LucideIcons.squareDashedMousePointer,
                          text: '${wordInfo.text} ~ ${wordInfo.span.payload}');
                },
              ),
            BlocSelector<BiblePaneBloc, BiblePaneState, List<BibleTranslation>>(
              selector: (state) =>
                  state.content.asMap.values.map((v) => v.meta).toList(),
              builder: (context, metas) {
                late final String text;
                if (metas.isEmpty) text = '...';
                if (metas.length > 1) {
                  text = metas.map((m) => m.abbreviation).join(' - ');
                }
                if (metas.length == 1) text = metas.first.abbreviation;
                return _PaneInfoItem(
                  tooltip: 'Open bibles',
                  icon: LucideIcons.bookOpen,
                  text: text,
                );
              },
            ),
            if (pl > 1) ActivePaneIndicator(id: paneId)
          ],
        ),
      ),
    );
  }
}
