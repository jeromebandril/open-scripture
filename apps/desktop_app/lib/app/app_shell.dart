import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../core/settings/settings_cubit.dart';
import '../features/bible_display/multi_pane_manager/presentation/widgets/multi_pane_container.dart';
import '../features/bible_searchbar/history/presentation/widgets/show_history_button.dart';
import '../features/bible_searchbar/search/presentation/widgets/bible_searchbar.dart';
import '../features/bible_searchbar/settings/domain/entities/searchbar_appearance_option.dart';
import '../features/bible_searchbar/settings/search_settings.dart';
import '../features/obs_live_overlay/presentation/widgets/obs_live_overlay_indicator.dart';
import '../features/remote_controller/presentation/widgets/remote_controller_indicator.dart';
import '../features/shortcuts/presentation/widgets/shortcuts_focus_scope.dart';
import '../features/shortcuts/presentation/widgets/shortcuts_host.dart';
import '../features/simple_presenter/presentation/widgets/presenter_host.dart';
import '../features/simple_presenter/presentation/widgets/presenter_indicator.dart';
import '../features/three_tap_navigator/presentation/widgets/three_tap_navigator.dart';
import '../shared/design_system/design_system.dart';
import 'settings/global_settings.dart';
import 'state/fullscreen_cubit.dart';
import 'state/interface_visibility_cubit.dart';
import 'widgets/dynamic_ui.dart';
import 'widgets/notification_host.dart';
import 'widgets/titlebar.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final isFullscreen = context.select((FullscreenCubit f) => f.state);
    final showMenuBar = context
        .select((InterfaceVisibilityCubit i) => i.state.isToolbarVisible);
    final isSearchbarCollapsed = context.select(
        (SettingsCubit<SearchSettings> s) =>
            s.state.searchbarAppearance == SearchbarAppearanceOption.collapsed);

    final enableDynamicInterface = (isFullscreen || kIsWeb) && !showMenuBar;

    // ShortcusHost must stay at the very root after the MaterialApp
    return ShortcutsHost(
      child: Scaffold(
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
                leftItems: isSearchbarCollapsed ? const [_AppHeader()] : null,
                centerItems: isSearchbarCollapsed ? null : [const _AppHeader()],
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
              child: PresenterHost(
                child: Stack(
                  children: [
                    //
                    // Bible Panes
                    //
                    const Positioned.fill(child: MultiPaneContainer()),
                    //
                    // Dynamic searchbar
                    //
                    if (enableDynamicInterface || isSearchbarCollapsed)
                      const DynamicSearchbar(),
                    //
                    // Dynamic History viewer
                    //
                    if (enableDynamicInterface) const DynamicHistory(),
                    //
                    //
                    //
                    const NotificationHost(),
                  ],
                ),
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
        ));
    final isSearchbarCollapsed = context.select(
        (SettingsCubit<SearchSettings> c) =>
            c.state.searchbarAppearance == SearchbarAppearanceOption.collapsed);
    final parentWidth = MediaQuery.of(context).size.width;

    final threeTapNav = globalSettings.enable3TapNavigator
        ? const ThreeTapNavigatorTrigger()
        : const SizedBox();

    final searchbarTheme = globalSettings.enableAdaptiveTitlebar
        ? const SearchBarThemeData(
            backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            side: WidgetStatePropertyAll(
              BorderSide(color: Colors.black12, width: 0.5),
            ),
            constraints: BoxConstraints(maxWidth: 50),
          )
        : null;

    final searchbarWidth =
        parentWidth <= AppBreakpoints.compact ? parentWidth * 0.4 : 300.0;

    final searchbar = isSearchbarCollapsed
        ? IconButton(
            onPressed: () =>
                ShortcutFocusScope.of(context).search.requestFocus(),
            tooltip: 'Search reference',
            icon: const Icon(LucideIcons.search),
          )
        : BSearchbar(
            width: searchbarWidth,
            theme: searchbarTheme,
          );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: isSearchbarCollapsed ? 0 : AppSpacing.xs,
      children: [
        threeTapNav,
        searchbar,
        const ShowHistoryButton(),
      ],
    );
  }
}
