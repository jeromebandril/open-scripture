import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/display_mode.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/core/app_state/fullscreen_cubit.dart';

import '../../shared/theme/tokens.dart';
import '../../shared/widgets/custom_icon_button.dart';

class ToolbarButton extends StatefulWidget {
  const ToolbarButton({super.key});

  @override
  State<ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<ToolbarButton> {
  final _controller = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  final double _menuGap = 5;

  Widget _buildOverlay(BuildContext context, OverlayChildLayoutInfo info) {
    final screen = MediaQuery.of(context).size;
    final top = info.childSize.height + _menuGap;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _controller.hide();
            },
          ),
        ),
        CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, top), // place under anchor
          child: BlockSemantics(
            blocking: true,
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(
                    screen.width,
                    screen.height * .4,
                  )),
                  //
                  // Here the custom widget
                  //
                  child: const ToolbarMenu()),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal.overlayChildLayoutBuilder(
        controller: _controller,
        overlayChildBuilder: _buildOverlay,
        child: CustomIconButton(
          Icons.handyman_rounded,
          tooltipMessage: 'Toolbar',
          onTap: () => _controller.show(),
        ),
      ),
    );
  }
}

class ToolbarMenu extends StatelessWidget {
  const ToolbarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final activePane =
        context.select((MultiPaneManagerCubit c) => c.activePane());

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          children: [
            const _SplitScreenIndicator(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<FullscreenCubit, bool>(
                  builder: (context, isFullscreen) {
                    return TextButton.icon(
                      onPressed: () => context.read<FullscreenCubit>().toggle(),
                      label: isFullscreen
                          ? const Text('Exit Fullscreen')
                          : const Text('Enter Fullscreen'),
                      icon: isFullscreen
                          ? const Icon(Icons.close_fullscreen_rounded)
                          : const Icon(Icons.open_in_full_rounded),
                    );
                  },
                ),
                TextButton.icon(
                  onPressed: () =>
                      activePane.bloc.add(const BiblePaneChooseBibles()),
                  label: Text('Set bible'),
                  icon: Icon(Icons.menu_book),
                ),
                TextButton.icon(
                    onPressed: () {
                      final evt =
                          activePane.bloc.state.dMode == DisplayMode.list
                              ? const BiblePaneSetDisplayMode(
                                  DisplayMode.presentation)
                              : const BiblePaneSetDisplayMode(DisplayMode.list);
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
              ],
            ),
          ],
        ),
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
        if (state.panes.length == 1) return SizedBox.shrink();

        return SizedBox(
          height: 32,
          child: Row(
            children: [
              const Text('Current active pane:  '),
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
          ),
        );
      },
    );
  }
}
