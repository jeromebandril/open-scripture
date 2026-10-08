import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../core/settings/settings_cubit.dart';
import '../features/bible_display/multi_pane_manager/presentation/widgets/multi_pane_container.dart';
import '../features/bible_searchbar/history/presentation/widgets/history_list.dart';
import '../features/bible_searchbar/history/presentation/widgets/show_history_button.dart';
import '../features/bible_searchbar/search/presentation/widgets/bible_searchbar.dart';
import '../features/obs_live_overlay/presentation/widgets/obs_live_overlay_indicator.dart';
import '../features/remote_controller/presentation/widgets/remote_controller_indicator.dart';
import '../features/shortcuts/presentation/widgets/shortcuts_focus_scope.dart';
import '../features/shortcuts/presentation/widgets/shortcuts_host.dart';
import '../features/simple_presenter/presentation/widgets/presenter_host.dart';
import '../features/simple_presenter/presentation/widgets/presenter_indicator.dart';
import '../features/three_tap_navigator/presentation/widgets/three_tap_navigator.dart';
import '../shared/design_system/design_system.dart';
import '../shared/widgets/floating_panel.dart';
import 'settings/global_settings.dart';
import 'state/fullscreen_cubit.dart';
import 'state/interface_visibility_cubit.dart';
import 'widgets/dynamic_searchbar.dart';
import 'widgets/notification_host.dart';
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
    final collapseSearchbarToIcon = context.select(
        (SettingsCubit<GlobalSettings> s) => s.state.collapseSearchbarToIcon);

    final screen = MediaQuery.of(context).size;

    final enableDynamicInterface = (isFullscreen || kIsWeb) && !showMenuBar;

    // ShortcusHost must be at the very root after the MaterialApp
    return ShortcutsHost(
      child: Scaffold(
        //
        // Bloc Listner to show a small floating notification
        // when user go full screen mode
        //
        body: Column(
          children: [
            //
            // Titlebar with controls
            //
            if (showMenuBar || (!isFullscreen && !kIsWeb))
              Titlebar(
                showMenuBar: true,
                showLogo: !isFullscreen && !kIsWeb,
                showButtons: !isFullscreen && !kIsWeb,
                leftItems:
                    collapseSearchbarToIcon ? const [_AppHeader()] : null,
                centerItems:
                    collapseSearchbarToIcon ? null : [const _AppHeader()],
                rightItems: kIsWeb
                    ? null
                    : const [
                        PresenterIndicator(),
                        ObsLiveOverlayIndicator(),
                        RemoteControllerIndicator(),
                      ],
              ),
            //
            // Main screen/workspace
            //
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PresenterHost(
                    child: Stack(
                      children: [
                        //
                        // Bible Panes
                        //
                        const Positioned.fill(child: MultiPaneContainer()),
                        //
                        // Dynamic searchbar
                        //
                        if (enableDynamicInterface || collapseSearchbarToIcon)
                          const DynamicSearchbar(),
                        //
                        // Dynamic History viewer
                        //
                        if (enableDynamicInterface)
                          FloatingPanel(
                            visible: showHistory,
                            maintainState: false,
                            top: screen.height * 0.08 + 100,
                            left: 0,
                            right: 0,
                            width: 350,
                            height: 250,
                            padding: const EdgeInsets.only(
                                right: 0,
                                left: 0,
                                top: AppSpacing.lg,
                                bottom: AppSpacing.md),
                            child: const HistoryList(size: HistoryListSize.big),
                          )
                      ],
                    ),
                  ),
                  const Positioned.fill(child: NotificationHost()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    final globalSettings = context.select((SettingsCubit<GlobalSettings> c) => (
          enable3TapNavigator: c.state.enable3TapNavigator,
          enableAdaptiveTitlebar: c.state.enableAdaptiveTitlebar,
          collapseSearchbarToIcon: c.state.collapseSearchbarToIcon
        ));
    final screenWidth = MediaQuery.of(context).size.width;

    final threeTapNav = globalSettings.enable3TapNavigator
        ? const ThreeTapNavigatorTrigger()
        : const SizedBox();

    final searchbar = globalSettings.collapseSearchbarToIcon
        ? IconButton(
            tooltip: 'Search reference',
            onPressed: () =>
                ShortcutFocusScope.of(context).search.requestFocus(),
            icon: const Icon(LucideIcons.search),
          )
        : BSearchbar(
            width:
                screenWidth <= AppBreakpoints.compact ? screenWidth * 0.4 : 300,
            theme: globalSettings.enableAdaptiveTitlebar
                ? const SearchBarThemeData(
                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.black12, width: 0.5),
                    ),
                  )
                : null,
          );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: globalSettings.collapseSearchbarToIcon ? 0 : AppSpacing.xs,
      children: [
        threeTapNav,
        searchbar,
        const ShowHistoryButton(),
      ],
    );
  }
}
