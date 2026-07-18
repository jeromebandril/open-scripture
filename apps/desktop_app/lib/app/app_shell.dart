import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/bible_display/multi_pane_manager/presentation/widgets/multi_pane_container.dart';
import '../features/bible_searchbar/history/presentation/widgets/history_list.dart';
import '../features/bible_searchbar/history/presentation/widgets/show_history_button.dart';
import '../features/bible_searchbar/search/presentation/widgets/bible_searchbar.dart';
import '../features/customizer/presentation/state/customizer_cubit.dart';
import '../features/obs_live_overlay/presentation/widgets/obs_live_overlay_indicator.dart';
import '../features/remote_controller/presentation/widgets/remote_controller_indicator.dart';
import '../features/shortcuts/presentation/widgets/shortcuts_host.dart';
import '../features/three_tap_navigator/presentation/widgets/three_tap_navigator.dart';
import '../features/window_stack_manager/presentation/widgets/window_stack_manager_host.dart';
import '../shared/design_system/design_system.dart';
import '../shared/widgets/floating_panel.dart';
import 'state/fullscreen_cubit.dart';
import 'state/interface_visibility_cubit.dart';
import 'widgets/dynamic_searchbar.dart';
import 'widgets/titlebar.dart';
import 'widgets/toolbar.dart';

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
    final enableDynamicInterface = (isFullscreen || kIsWeb) && !showMenuBar;

    // ShortcusHost must be at the very root after the MaterialApp
    return ShortcutsHost(
      child: Scaffold(
        //
        // Bloc Listner to show a small floating notification
        // when user go full screen mode
        //
        body: WindowStackManagerHost(
          child: Column(
            children: [
              //
              // Titlebar with controls
              //
              if (showMenuBar || (!isFullscreen && !kIsWeb))
                Titlebar(
                  showMenuBar: true,
                  showLogo: !isFullscreen && !kIsWeb,
                  showButtons: !isFullscreen && !kIsWeb,
                  leftItems: [
                    const ToolbarButton(),
                  ],
                  centerItems: [
                    const _AppHeader(),
                  ],
                  rightItems: kIsWeb
                      ? null
                      : [
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
                      const DynamicSearchbar(),
                      //
                      // Dynamic History viewer
                      //
                      FloatingPanel(
                        visible: showHistory,
                        top: screen.height * 0.08 + 100,
                        left: 0,
                        right: 0,
                        width: 350,
                        height: 250,
                        child: const HistoryList(size: HistoryListSize.big),
                      )
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
