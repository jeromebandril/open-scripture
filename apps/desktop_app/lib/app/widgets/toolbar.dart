import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/bible_display/bible_pane/domain/display_mode.dart';
import '../../features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import '../../features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../features/shortcuts/domain/models/app_command.dart';
import '../../features/shortcuts/presentation/models/app_command_shortcuts.dart';
import '../../features/shortcuts/presentation/widgets/shortcut_view.dart';
import '../../shared/design_system/tokens/tokens.dart';
import '../../shared/widgets/dropdown_menu_anchor.dart';
import '../state/fullscreen_cubit.dart';
import '../state/interface_visibility_cubit.dart';

class ToolbarButton extends StatefulWidget {
  const ToolbarButton({super.key});

  @override
  State<ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<ToolbarButton> {
  late final ValueNotifier<bool> _menuVisible;

  @override
  void initState() {
    super.initState();
    final v = context.read<InterfaceVisibilityCubit>().state.isToolMenuVisible;
    _menuVisible = ValueNotifier(v);
  }

  @override
  void dispose() {
    _menuVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InterfaceVisibilityCubit, InterfaceVisibilityState>(
      listener: (context, state) =>
          _menuVisible.value = state.isToolMenuVisible,
      child: DropdownMenuAnchor(
        menuVisible: _menuVisible,
        menuWidth: 430, // absolute width
        menuHeight: 600,
        onDismiss: () => context
            .read<InterfaceVisibilityCubit>()
            .setVisibility(toolmenu: false),
        trigger: IconButton(
          tooltip: 'Tools menu',
          visualDensity: VisualDensity.compact,
          icon: Icon(LucideIcons.toolbox),
          onPressed: () =>
              context.read<InterfaceVisibilityCubit>().toggleToolMenu(),
        ),
        menuContent: const ToolbarMenu(),
      ),
    );
  }
}

class ToolbarMenu extends StatelessWidget {
  const ToolbarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final panesNumber =
        context.select((MultiPaneManagerCubit c) => c.state.panes.length);
    final activePane =
        context.select((MultiPaneManagerCubit c) => c.activePane());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xs,
            children: [
              //
              // GLOBAL controls
              //
              _Control(
                command: AppCommand.toggleFullscreen,
                child: BlocBuilder<FullscreenCubit, bool>(
                  builder: (context, isFullscreen) {
                    return TextButton.icon(
                      onPressed: () => context.read<FullscreenCubit>().toggle(),
                      label: isFullscreen
                          ? const Text('Exit Fullscreen')
                          : const Text('Enter Fullscreen'),
                      icon: isFullscreen
                          ? const Icon(LucideIcons.minimize2)
                          : const Icon(LucideIcons.maximize2),
                    );
                  },
                ),
              ),
              _Control(
                command: AppCommand.toggleToolbar,
                addInfo: kIsWeb ? null : '(only when fullscreen)',
                child: BlocBuilder<InterfaceVisibilityCubit,
                    InterfaceVisibilityState>(builder: (context, state) {
                  return TextButton.icon(
                    onPressed:
                        context.select((FullscreenCubit c) => c.state) || kIsWeb
                            ? () => context
                                .read<InterfaceVisibilityCubit>()
                                .toggleToolbar()
                            : null,
                    label: state.isToolbarVisible
                        ? const Text('Hide top bar')
                        : const Text('Show top bar'),
                    icon: state.isToolbarVisible
                        ? const Icon(LucideIcons.panelTopClose)
                        : const Icon(LucideIcons.panelTopOpen),
                  );
                }),
              ),
              //
              // PANE specific
              //
              const Divider(),
              const _SplitScreenIndicator(),
              _Control(
                command: AppCommand.changeBible,
                child: TextButton.icon(
                  onPressed: () =>
                      activePane.bloc.add(const BiblePaneChooseBibles()),
                  label: Text('Set bible'),
                  icon: Icon(LucideIcons.bookOpen),
                ),
              ),
              _Control(
                command: AppCommand.switchDisplayMode,
                child: TextButton.icon(
                    onPressed: () {
                      final evt =
                          activePane.bloc.state.dMode == DisplayMode.list
                              ? const BiblePaneSetDisplayMode(
                                  DisplayMode.presentation)
                              : const BiblePaneSetDisplayMode(DisplayMode.list);
                      activePane.bloc.add(evt);
                    },
                    label: const Text('Switch display mode'),
                    icon: const Icon(LucideIcons.monitor)),
              ),
              _Control(
                command: AppCommand.addPane,
                child: TextButton.icon(
                  onPressed: () =>
                      context.read<MultiPaneManagerCubit>().splitNewPane(),
                  label: Text('Add split screen'),
                  icon: Icon(LucideIcons.squareSplitHorizontal),
                ),
              ),
              if (panesNumber > 1)
                _Control(
                  command: AppCommand.removePane,
                  child: TextButton.icon(
                    onPressed: () => context
                        .read<MultiPaneManagerCubit>()
                        .closePane(context
                            .read<MultiPaneManagerCubit>()
                            .state
                            .activePaneId),
                    label: Text('Remove split screen'),
                    icon: Icon(Icons.close_rounded),
                  ),
                ),
              _Control(
                command: AppCommand.zoomIn,
                child: TextButton.icon(
                  onPressed: () =>
                      activePane.textScalerCubit.zoomIn(multiplier: 4),
                  label: Text('Zoom In'),
                  icon: Icon(LucideIcons.zoomIn),
                ),
              ),
              _Control(
                command: AppCommand.zoomOut,
                child: TextButton.icon(
                  onPressed: () =>
                      activePane.textScalerCubit.zoomOut(multiplier: 4),
                  label: Text('Zoom Out'),
                  icon: Icon(LucideIcons.zoomOut),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Control extends StatelessWidget {
  const _Control({required this.command, required this.child, this.addInfo});

  final Widget child;
  final AppCommand command;
  final String? addInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        child,
        if (addInfo != null)
          Text(
            addInfo!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        Spacer(),
        ShortcutView(activator: appCommandShortcuts[command], fontSize: 11),
      ],
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
          child: _Control(
            command: AppCommand.nextPane,
            child: Row(
              children: [
                SizedBox(width: 12),
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
          ),
        );
      },
    );
  }
}
