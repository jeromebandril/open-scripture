import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/models/display_mode.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/core/app_state/fullscreen_cubit.dart';
import 'package:open_scripture/core/app_state/toolbar_cubit.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final activePane =
        context.select((MultiPaneManagerCubit c) => c.activePane());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          SizedBox(
            height: 32,
            child: Row(
              children: [
                Checkbox(
                    value: context.select(
                        (ToolbarCubit c) => c.state.highlightActivePane),
                    onChanged: (val) {
                      context
                          .read<ToolbarCubit>()
                          .setHightlightActivePane(val!);
                    },
                    semanticLabel: 'Highlight active pane'),
                const Text('Highlight active pane'),
                const VerticalDivider(),
                const Text('Current active pane:  '),
                const _SplitScreenIndicator()
              ],
            ),
          ),
          Wrap(
            // crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () =>
                    activePane.bloc.add(const BiblePaneChooseBibles()),
                label: Text('Set bible'),
                icon: Icon(Icons.menu_book),
              ),
              TextButton.icon(
                  onPressed: () {
                    final evt =
                        activePane.bloc.state.dMode == DisplayMode.normal
                            ? const BiblePaneSetDisplayMode(
                                DisplayMode.presentation)
                            : const BiblePaneSetDisplayMode(DisplayMode.normal);
                    activePane.bloc.add(evt);
                  },
                  label: const Text('Switch display mode'),
                  icon: const Icon(Icons.fit_screen_rounded)),
              TextButton.icon(
                onPressed: () =>
                    context.read<MultiPaneManagerCubit>().splitNewPane(),
                label: Text('Add split screen'),
                icon: Icon(Icons.vertical_split_rounded),
              ),
              TextButton.icon(
                onPressed: () => context
                    .read<MultiPaneManagerCubit>()
                    .closePane(context
                        .read<MultiPaneManagerCubit>()
                        .state
                        .activePaneId),
                label: Text('Remove split screen'),
                icon: Icon(Icons.close_rounded),
              ),
              TextButton.icon(
                onPressed: () =>
                    activePane.textScalerCubit.zoomIn(multiplier: 4),
                label: Text('Zoom In'),
                icon: Icon(Icons.zoom_in_rounded),
              ),
              TextButton.icon(
                onPressed: () =>
                    activePane.textScalerCubit.zoomOut(multiplier: 4),
                label: Text('Zoom Out'),
                icon: Icon(Icons.zoom_out_rounded),
              ),
              BlocBuilder<FullscreenCubit, bool>(
                builder: (context, isFullscreen) {
                  return TextButton.icon(
                    onPressed: () => context.read<FullscreenCubit>().toggle(),
                    label: isFullscreen
                        ? const Text('Exit fullscreen')
                        : const Text('Enter fullscreen'),
                    icon: isFullscreen
                        ? const Icon(Icons.fullscreen_exit_rounded)
                        : const Icon(Icons.fullscreen_rounded),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SplitScreenIndicator extends StatelessWidget {
  const _SplitScreenIndicator();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultiPaneManagerCubit, PaneManagerState>(
      builder: (context, state) {
        return Row(
          children: [
            for (final i in state.panes) ...[
              i.id == state.activePaneId
                  ? Icon(
                      Icons.panorama_vertical_select_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : Icon(
                      Icons.panorama_vertical_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
            ]
          ],
        );
      },
    );
  }
}
