import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/app_state/fullscreen_cubit.dart';
import '../core/app_state/history_visibility_cubit.dart';
import '../core/app_state/menubar_visibility_cubit.dart';
import '../core/app_state/toolbar_cubit.dart';
import '../features/bible_display/multi_pane_manager/presentation/widgets/multi_pane_container.dart';
import '../features/bible_searchbar/presentation/widgets/bible_searchbar.dart';
import '../features/bible_searchbar/presentation/widgets/history_list_overlay.dart';
import '../features/bible_searchbar/presentation/widgets/show_history_button.dart';
import '../features/customizer/presentation/state/customizer_cubit.dart';
import '../features/menubar/presentation/widgets/menubar.dart';
import '../features/obs_live_overlay/presentation/widgets/obs_live_overlay_indicator.dart';
import '../features/remote_controller/presentation/widgets/remote_controller_indicator.dart';
import '../features/shortcuts/presentation/widgets/shortcuts_host.dart';
import '../features/three_tap_navigator/presentation/widgets/three_tap_navigator.dart';
import '../features/window_stack_manager/presentation/widgets/window_stack_manager_wrapper.dart';
import '../shared/theme/tokens.dart';
import 'widgets/titlebar.dart';
import 'widgets/toolbar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final FocusNode _searchbarFocusNode;
  late final FocusNode _historyFocusNode;
  late final FocusNode _rootFocusNode;

  bool _searchbarHasFocus = false;

  @override
  void initState() {
    super.initState();
    _searchbarFocusNode = FocusNode(debugLabel: 'searchbar');
    _historyFocusNode = FocusNode(debugLabel: 'history');
    _rootFocusNode = FocusNode(debugLabel: 'root');
    _searchbarFocusNode.addListener(_searchbarFocusNodeListener);
  }

  @override
  void dispose() {
    _searchbarFocusNode.dispose();
    _historyFocusNode.dispose();
    _rootFocusNode.dispose();
    super.dispose();
  }

  void _searchbarFocusNodeListener() {
    setState(() => _searchbarHasFocus = _searchbarFocusNode.hasFocus);
  }

  // Return focus to root after search finishes
  void _returnFocusToRoot() {
    // This ensures there is always a focused node to receive shortcuts.
    _rootFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isFullscreen = context.select((FullscreenCubit f) => f.state);
    final showMenuBar = context.select((MenubarCubit t) => t.state);
    final showToolBar = context.select((ToolbarCubit t) => t.state.isVisible);
    final showHistory = context.select((HistoryVisibilityCubit c) => c.state);
    final screen = MediaQuery.of(context).size;

    // ShortcusHost must be at the very root after the MaterialApp
    return ShortcutsHost(
      rootFocusNode: _rootFocusNode,
      searchFocusNode: _searchbarFocusNode,
      historyFocusNode: _historyFocusNode,
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        //
        // Manages the stacks of windosw that may occur when opening
        // popups or secondary pages in the form of a window (e.g. settings menu)
        //
        body: WindowStackManagerWrapper(
          child: Column(
            children: [
              //
              // Simulated classic desktop toolbar
              //
              if (showMenuBar || !isFullscreen) ...[
                Titlebar(
                  menuBar: const MyMenuBar(),
                  toolbar: _AppHeader(
                    searchbarFocusNode: _searchbarFocusNode,
                    returnFocusToRoot: _returnFocusToRoot,
                  ),
                  showLogo: !isFullscreen,
                  showButtons: !isFullscreen,
                  showMenuBar: true,
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  child: showToolBar
                      ? const Toolbar()
                      : const SizedBox(width: double.infinity, height: 0),
                ),
              ],
              //
              // BIBLE PANES
              //
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: const MultiPaneContainer()),
                    //
                    // Dynamic fullscreen only interfaces
                    //
                    if (isFullscreen && !showMenuBar) ...[
                      //
                      // Dynamic searchbar
                      //
                      Positioned(
                        top: screen.height * 0.08,
                        right: 0,
                        left: 0,
                        child: Visibility(
                          maintainFocusability: true,
                          maintainState: true,
                          visible: _searchbarHasFocus,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: BSearchbar(
                                height: 48,
                                width: 300,
                                focusNode: _searchbarFocusNode,
                                onSubmitted: () => _returnFocusToRoot(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //
                      // Dynamic History viewer
                      //
                      if (isFullscreen && !showMenuBar)
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
                                  onSelected: () => _returnFocusToRoot(),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                    //
                    // Other interfaces
                    //
                    if (!isFullscreen)
                      const Positioned(
                        top: AppSpacing.sm,
                        right: AppSpacing.sm,
                        child: RemoteControllerIndicator(),
                      )
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
  const _AppHeader({
    required this.searchbarFocusNode,
    required this.returnFocusToRoot,
  });

  final FocusNode searchbarFocusNode;
  final void Function() returnFocusToRoot;

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
          focusNode: searchbarFocusNode,
          width:
              screenWidth <= AppBreakpoints.compact ? screenWidth * 0.4 : 300,
          onSubmitted: () => returnFocusToRoot(),
          //onEditComplete: () => _returnFocusToRoot(),
        ),
        if (screenWidth > AppBreakpoints.compact) ...[
          ShowHistoryButton(),
          const ObsLiveOverlayIndicator(),
        ]
      ],
    );
  }
}
