import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../app/state/fullscreen_cubit.dart';
import '../../../../../app/state/interface_visibility_cubit.dart';
import '../../../../obs_live_overlay/presentation/state/obs_live_overlay_cubit.dart';
import '../../../../remote_controller/presentation/state/remote_controller_cubit.dart';
import '../../../../settings_window/presentation/models/settings_route.dart';
import '../../domain/display_mode.dart';
import '../../domain/entities/word_info.dart';
import '../state/bible_pane_bloc.dart';
import '../../../multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../../multi_pane_manager/presentation/widgets/active_pane_indicator.dart';
import '../../../settings/presentation/widgets/bible_view_settings_provider.dart';
import '../../../../simple_presenter/presentation/cubit/presenter_cubit.dart';
import '../../../../text_scaler/presentation/state/text_scaler_cubit.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/domain/entities/bible_translation.dart';

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
  static const _emptyDataPlaceholder = '...';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pl =
        context.select((MultiPaneManagerCubit b) => b.state.panes.length);
    final paneId = context.read<BiblePaneBloc>().state.paneId;
    final enableStrongWords =
        BibleViewSettingsScope.of(context).enableStrongWordsRender;

    return DefaultTextStyle(
      style: theme.textTheme.bodySmall ??
          TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
      child: Container(
        height: PaneInfo.kHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xs),
            topRight: Radius.circular(AppRadius.xs),
          ),
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(240),
        ),
        child: Row(
          children: [
            const GlobalStatus(),
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
                    text: '${verseCount ?? _emptyDataPlaceholder}');
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
                if (metas.isEmpty) text = _emptyDataPlaceholder;
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

class GlobalStatus extends StatelessWidget {
  const GlobalStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final isToolbarVisible = context
        .select((InterfaceVisibilityCubit p) => p.state.isToolbarVisible);
    final isFullscreen = context.select((FullscreenCubit p) => p.state);
    final activeId =
        context.select((MultiPaneManagerCubit p) => p.state.activePaneId);
    final paneId = context.read<BiblePaneBloc>().state.paneId;

    return activeId != paneId || isToolbarVisible || !isFullscreen
        ? const SizedBox()
        : Row(
            children: [
              BlocBuilder<PresenterCubit, PresenterState>(
                buildWhen: (prev, curr) =>
                    prev.currentSlideIndex != curr.currentSlideIndex ||
                    prev.numberOfSlides != curr.numberOfSlides,
                builder: (context, state) {
                  return state.numberOfSlides == 0
                      ? const SizedBox()
                      : _PaneInfoItem(
                          tooltip: 'Slides',
                          icon: LucideIcons.rectangleCircle,
                          text:
                              '${state.currentSlideIndex + 1}/${state.numberOfSlides} ${state.getCurrentSlide()?.title}',
                        );
                },
              ),
              BlocBuilder<ObsLiveOverlayCubit, ObsLiveOverlayState>(
                buildWhen: (prev, curr) =>
                    prev.isRunning != curr.isRunning ||
                    prev.snapshot != curr.snapshot,
                builder: (context, state) {
                  return !state.isRunning
                      ? const SizedBox()
                      : _PaneInfoItem(
                          tooltip: '(RC) OBS Live Overlay',
                          icon: SettingsPage.obsLiveOverlay.icon,
                          text: state.currentVerseStr,
                        );
                },
              ),
              BlocBuilder<RemoteControllerCubit, RemoteControllerState>(
                buildWhen: (prev, curr) =>
                    prev.isRunning != curr.isRunning ||
                    prev.connectedClients != curr.connectedClients,
                builder: (context, state) {
                  final connectedClients = state.connectedClients.length;
                  return !state.isRunning
                      ? const SizedBox()
                      : _PaneInfoItem(
                          tooltip: '(RC) Connected clients: $connectedClients',
                          icon: SettingsPage.remoteController.icon,
                          text: connectedClients.toString(),
                        );
                },
              ),
              const VerticalDivider(),
            ],
          );
  }
}
