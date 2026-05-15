import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/app/widgets/toolbar.dart';

import '../core/app_state/fullscreen_cubit.dart';
import '../core/app_state/interface_visibility_cubit.dart';
import '../features/bible_display/multi_pane_manager/presentation/widgets/multi_pane_container.dart';
import '../features/bible_searchbar/presentation/widgets/bible_searchbar.dart';
import '../features/bible_searchbar/presentation/widgets/history_list_overlay.dart';
import '../features/bible_searchbar/presentation/widgets/show_history_button.dart';
import '../features/customizer/presentation/state/customizer_cubit.dart';
import '../features/remote_controller/presentation/widgets/remote_controller_indicator.dart';
import '../features/obs_live_overlay/presentation/widgets/obs_live_overlay_indicator.dart';
import '../features/shortcuts/presentation/widgets/shortcuts_focus_scope.dart';
import '../features/shortcuts/presentation/widgets/shortcuts_host.dart';
import '../features/three_tap_navigator/presentation/widgets/three_tap_navigator.dart';
import '../features/window_stack_manager/presentation/widgets/window_stack_manager_host.dart';
import '../shared/theme/tokens.dart';
import 'widgets/titlebar.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final isFullscreen = context.select((FullscreenCubit f) => f.state);
    final showMenuBar = context
        .select((InterfaceVisibilityCubit i) => i.state.isToolbarVisible);
    final showHistory = context
        .select((InterfaceVisibilityCubit i) => i.state.isHistoryVisible);
    final screen = MediaQuery.of(context).size;
    final enableDynamicInterface = isFullscreen && !showMenuBar;

    // ShortcusHost must be at the very root after the MaterialApp
    return ShortcutsHost(
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        //
        // Manages the stacks of windosw that may occur when opening
        // popups or secondary pages in the form of a window (e.g. settings menu)
        //
        body: WindowStackManagerHost(
          child: Column(
            children: [
              //
              // Titlebar with controls
              //
              if (showMenuBar || !isFullscreen)
                Titlebar(
                  showMenuBar: true,
                  showLogo: !isFullscreen,
                  showButtons: !isFullscreen,
                  leftItems: [
                    const ToolbarButton(),
                  ],
                  centerItems: [
                    const _AppHeader(),
                  ],
                  rightItems: [
                    const ObsLiveOverlayIndicator(),
                    const RemoteControllerIndicator(),
                  ],
                ),
              //
              // Main screen/workspace
              //
              Expanded(
                child: Stack(
                  children: [
                    //
                    // Bible Panes
                    //
                    Positioned.fill(child: const MultiPaneContainer()),
                    //
                    // Dynamic/fullscreen only interfaces
                    //
                    if (enableDynamicInterface) ...[
                      //
                      // Dynamic searchbar
                      //
                      Positioned(
                        top: screen.height * 0.08,
                        right: 0,
                        left: 0,
                        child: Builder(builder: (context) {
                          final focusNode = ShortcutFocusScope.of(context)
                              .search
                            ..skipTraversal = true;
                          return ListenableBuilder(
                            listenable: focusNode,
                            builder: (_, __) {
                              return Visibility(
                                maintainFocusability: true,
                                maintainState: true,
                                visible: focusNode.hasFocus,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).dividerColor,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const BSearchbar(
                                        height: 48, width: 300),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                      //
                      // Dynamic History viewer
                      //
                      if (enableDynamicInterface)
                        Positioned(
                          top: screen.height * 0.08 + 100,
                          right: 0,
                          left: 0,
                          child: Visibility(
                            maintainFocusability: true,
                            maintainState: true,
                            visible: showHistory,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).dividerColor,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.lg),
                                ),
                                child: HistoryListOverlay(
                                  constraints: screen,
                                  width: 350,
                                  size: HistoryListSize.big,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    final enable3TapNav = context.select(
      (CustomizerCubit c) => c.state.app.enable3TapNavigator,
    );
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      spacing: 4,
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (enable3TapNav && screenWidth > AppBreakpoints.compact)
          const ThreeTapNavigatorTrigger(),
        BSearchbar(
          width:
              screenWidth <= AppBreakpoints.compact ? screenWidth * 0.4 : 300,
          //onEditComplete: () => _returnFocusToRoot(),
        ),
        if (screenWidth > AppBreakpoints.compact) ShowHistoryButton(),
      ],
    );
  }
}
