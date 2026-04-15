import 'package:flutter/material.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/cubit/obs_overlay/obs_live_overlay_cubit.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/widgets/obs_live_overlay_indicator.dart';
import 'package:open_scripture/shared/presentation/cubit/history_visibility_cubit.dart';
import 'package:open_scripture/shared/presentation/cubit/fullscreen_cubit.dart';
import 'package:open_scripture/shared/presentation/cubit/menubar_visibility_cubit.dart';
import 'package:open_scripture/shared/presentation/widgets/help_widget.dart';
import 'package:open_scripture/shared/presentation/widgets/titlebar.dart';
import 'package:open_scripture/features/b_searchbar/domain/repositories/b_search_intent_type.dart';
import 'package:open_scripture/features/b_searchbar/presenter/widgets/parts/history_list_overlay.dart';
import 'package:open_scripture/features/customizer/presentation/models/bible_view_list_theme.dart';
import 'package:open_scripture/features/customizer/presentation/models/bible_view_presentation_theme.dart';
import 'package:open_scripture/features/menubar/presentation/widgets/menubar.dart';
import 'package:open_scripture/shared/presentation/widgets/toolbar.dart';
import 'package:open_scripture/shared/theme/tokens.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'features/b_searchbar/presenter/widgets/bible_searchbar.dart';
import 'features/b_searchbar/presenter/widgets/show_history_button.dart';
import 'features/obs_live_overlay/presentation/cubit/obs_overlay_settinsg/obs_live_overlay_settings_cubit.dart';
import 'features/three_tap_navigator/presentation/widgets/three_tap_navigator.dart';
import 'features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import 'features/bible_display/bible_pane/presentation/navigation_bus.dart';
import 'features/bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import 'features/bible_display/split_screen/presenter/widgets/split_view_container.dart';
import 'features/bible_installer_manager/presentation/bloc/installed_bibles/installed_bibles_bloc.dart';
import 'features/customizer/domain/entities/app_theme_settings.dart';
import 'features/customizer/presentation/cubit/customizer_cubit.dart';
import 'features/customizer/presentation/models/bible_pane_general_theme.dart';
import 'features/shortcuts/presentation/widget/shortcuts_host.dart';
import 'features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
import 'features/window_stack_manager/presentation/widgets/window_stack_manager_wrapper.dart';
import 'injection_container.dart' as di;
import 'shared/presentation/cubit/toolbar_cubit.dart';

void main() async {
  await di.init();

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(1000, 600),
    minimumSize: Size(300, 200),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<CustomizerCubit>(),
      child: BlocBuilder<CustomizerCubit, CustomizerState>(
        buildWhen: (prev, curr) {
          // Only rebuild MaterialApp when app-wide theme changes.
          return prev.app != curr.app ||
              prev.pane != curr.pane ||
              prev.presentTheme != curr.presentTheme ||
              prev.listTheme != curr.listTheme;
        },
        builder: (context, state) {
          final builder = const AppThemeBuilder();

          final biblePaneTheme = state.pane
              .toExtension()
              .copyWith(accentColor: state.app.accentColor);

          final presentTheme = state.presentTheme.toExtension();

          final listTheme = state.listTheme.toExtension();

          final light = builder.buildLight(state.app).copyWith(
            extensions: <ThemeExtension<dynamic>>[
              biblePaneTheme,
              presentTheme,
              listTheme
            ],
          );
          final dark = builder.buildDark(state.app).copyWith(
            extensions: <ThemeExtension<dynamic>>[
              biblePaneTheme,
              presentTheme,
              listTheme
            ],
          );

          return MaterialApp(
            title: 'Open Scripture',
            themeMode: state.app.mode,
            darkTheme: dark,
            theme: light,
            debugShowCheckedModeBanner: false,
            home: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => di.sl<ObsLiveOverlayCubit>()),
                BlocProvider(
                    create: (_) => di.sl<ObsLiveOverlaySettingsCubit>()),
                BlocProvider(create: (_) => di.sl<HistoryVisibilityCubit>()),
                BlocProvider(create: (_) => di.sl<PaneManagerCubit>()),
                BlocProvider(create: (_) => di.sl<MenubarCubit>()),
                BlocProvider(create: (_) => di.sl<ToolbarCubit>()),
                BlocProvider(create: (_) => di.sl<FullscreenCubit>()..init()),
                BlocProvider(create: (_) => di.sl<WindowStackManagerBloc>()),
                BlocProvider(
                    create: (_) => di.sl<InstalledBiblesBloc>()
                      ..add(InstalledBiblesLoad())),
                BlocProvider(create: (_) => di.sl<BSearchbarBloc>()),
              ],
              child: const Home(),
            ),
          );
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              if (showMenuBar || !isFullscreen)
                Titlebar(
                  menuBar: !showMenuBar && isFullscreen
                      ? Tooltip(
                          message:
                              'Menu bar is hidden, press  CTRL+O  to toggle',
                          child: Icon(
                            Icons.visibility_off_outlined,
                            size: 20,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        )
                      : const MyMenuBar(),
                  toolbar: _AppHeader(
                    searchbarFocusNode: _searchbarFocusNode,
                    returnFocusToRoot: _returnFocusToRoot,
                  ),
                  showLogo: !isFullscreen,
                  showButtons: !isFullscreen,
                  showMenuBar: true,
                ),
              //
              // Toolbar
              //
              AnimatedSize(
                duration: const Duration(milliseconds: 128),
                curve: Curves.easeInOut,
                child: showToolBar ? const Toolbar() : const SizedBox.shrink(),
              ),
              //
              // BIBLE PANES
              //
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: BlocListener<BSearchbarBloc, BSearchbarState>(
                        listenWhen: (prev, curr) =>
                            prev.referenceResult != curr.referenceResult ||
                            prev.results != curr.results,
                        listener: (context, state) {
                          final ref = state.referenceResult;
                          if (ref == null && state.results.isEmpty) return;

                          final BiblePaneEvent event =
                              switch (state.intentType) {
                            BSearchIntentType.gotoReference =>
                              BiblePaneDisplayChapter(
                                ref: ref!,
                                source: IntentSource.searchbar,
                              ),
                            BSearchIntentType.gotoVerseNumber =>
                              BiblePaneJustChangeRef(
                                ref: ref!,
                                source: IntentSource.searchbar,
                                saveHistory: true,
                              ),
                            BSearchIntentType.findByString =>
                              BiblePaneDisplayVerses(state.results)
                          };

                          context
                              .read<PaneManagerCubit>()
                              .activePane()
                              .bloc
                              .add(event);
                        },
                        child: MultipleBiblePanes(),
                      ),
                    ),
                    //
                    // Dynamic searchbar
                    //
                    if (isFullscreen && !showMenuBar)
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
                                focusNode: _searchbarFocusNode,
                                onSubmitted: () => _returnFocusToRoot(),
                                //onEditComplete: () => _returnFocusToRoot(),
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
                                width: 400,
                                size: HistoryListSize.big,
                                onSelected: () => _returnFocusToRoot(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    //
                    // Top right interface
                    //
                    Positioned.fill(
                        child: Align(
                      alignment: AlignmentGeometry.topRight,
                      child: SizedBox(
                        height: 48,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //
                            // OBS Live Overlay
                            //
                            if (isFullscreen && !showMenuBar)
                              const ObsLiveOverlayIndicator(),
                            //
                            // Help button when all interface is hidden
                            //
                            if (isFullscreen && !showMenuBar)
                              const HelpTriggerBtn(),
                          ],
                        ),
                      ),
                    )),
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
    // final alignment = context.select(
    //   (CustomizerCubit c) => c.state.app.searchbarPosition,
    // );
    // final isFullscreen = context.select((FullscreenCubit c) => c.state);
    // final showToolbar = context.select((ToolbarCubit t) => t.state);
    // final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
    // final enableHangingRefs =
    //     Theme.of(context).extension<BibleViewListTheme>()!.enableHangingRefs;
    final enable3TapNav = context.select(
      (CustomizerCubit c) => c.state.app.enable3TapNavigator,
    );

    return Row(
      spacing: 4,
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (enable3TapNav) const ThreeTapNavigatorTrigger(),
        BSearchbar(
          focusNode: searchbarFocusNode,
          onSubmitted: () => returnFocusToRoot(),
          //onEditComplete: () => _returnFocusToRoot(),
        ),
        ShowHistoryButton(),
        const ObsLiveOverlayIndicator(),
      ],
    );
  }
}


        //
        // if (enableHangingRefs)
        //   Builder(builder: (context) {
        //     final activePaneBloc =
        //         context.select((PaneManagerCubit pm) => pm.activeBloc());

        //     return BlocProvider.value(
        //       value: activePaneBloc,
        //       child: BlocBuilder<BiblePaneBloc, BiblePaneState>(
        //         buildWhen: (prev, curr) => prev.reference != curr.reference,
        //         builder: (context, state) {
        //           return Padding(
        //             padding: EdgeInsets.only(
        //               top: enableDynamicInterface ? 18 : 0,
        //               bottom: 18,
        //             ),
        //             child: Text(
        //               state.reference.toString(),
        //               style: TextStyle(
        //                 fontWeight: FontWeight.bold,
        //                 fontFamily: paneTheme.referenceFont,
        //                 color: Theme.of(context).colorScheme.onSurface,
        //                 fontSize: 42,
        //               ),
        //             ),
        //           );
        //         },
        //       ),
        //     );
        //   })