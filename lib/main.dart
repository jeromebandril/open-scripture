import 'package:flutter/material.dart';
import 'package:the_smyrna_bible_v2/core/presentation/cubit/display_mode_cubit.dart';
import 'package:the_smyrna_bible_v2/core/presentation/cubit/fullscreen_cubit.dart';
import 'package:the_smyrna_bible_v2/core/presentation/cubit/toolbar_cubit.dart';
import 'package:the_smyrna_bible_v2/core/presentation/widgets/help_widget.dart';
import 'package:the_smyrna_bible_v2/core/presentation/widgets/titlebar.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/domain/repositories/b_search_intent_type.dart';
import 'package:the_smyrna_bible_v2/features/toolbar/presentation/widgets/toolbar.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'features/b_searchbar/presenter/widgets/bible_searchbar.dart';
import 'features/b_searchbar/presenter/widgets/show_history_button.dart';
import 'features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import 'features/bible_display/bible_pane/presentation/navigation_bus.dart';
import 'features/bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import 'features/bible_display/split_screen/presenter/widgets/split_view_container.dart';
import 'features/bible_display/split_screen/presenter/widgets/parts/split_view_controllers.dart';
import 'features/bible_installer_manager/presentation/bloc/installed_bibles/installed_bibles_bloc.dart';
import 'features/customizer/domain/entities/app_theme.dart';
import 'features/customizer/domain/entities/bible_pane_theme.dart';
import 'features/customizer/presentation/cubit/customizer_cubit.dart';
import 'features/keybindings/presentation/widget/keybindings_host.dart';
import 'features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
import 'features/window_stack_manager/presentation/widgets/window_stack_manager_wrapper.dart';
import 'injection_container.dart' as di;

void main() async {
  await di.init();

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(1000, 600),
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
          return prev.app != curr.app || prev.pane != curr.pane;
        },
        builder: (context, state) {
          final builder = const AppThemeBuilder();

          final biblePaneTheme = state.pane
              .toExtension()
              .copyWith(accentColor: state.app.accentColor);

          final light = builder.buildLight(state.app).copyWith(
            extensions: <ThemeExtension<dynamic>>[biblePaneTheme],
          );
          final dark = builder.buildDark(state.app).copyWith(
            extensions: <ThemeExtension<dynamic>>[biblePaneTheme],
          );

          return MaterialApp(
            title: 'Bible App',
            themeMode: state.app.mode,
            darkTheme: dark,
            theme: light,
            debugShowCheckedModeBanner: false,
            home: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => di.sl<PaneManagerCubit>()),
                BlocProvider(create: (_) => di.sl<ToolbarCubit>()),
                BlocProvider(create: (_) => di.sl<DisplayModeCubit>()),
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
  late final FocusNode _rootFocusNode;

  bool _searchbarHasFocus = false;

  @override
  void initState() {
    super.initState();
    _searchbarFocusNode = FocusNode(debugLabel: 'searchbar');
    _rootFocusNode = FocusNode(debugLabel: 'root');
    _searchbarFocusNode.addListener(_searchbarFocusNodeListener);
  }

  @override
  void dispose() {
    _searchbarFocusNode.dispose();
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
    // final backgroundColor = context.select(
    //   (CustomizerCubit c) => c.state.theme.backgroundColor,
    // );
    // final isCustomTheme = context.select(
    //   (CustomizerCubit c) => c.state.theme.enableCustomTheme,
    // );
    // final useBackgroundColorAsAppColor = context.select(
    //   (CustomizerCubit c) => c.state.theme.useBackgroundColorAsAppColor,
    // );
    final enableDynamicSearchbar = context.select(
      (CustomizerCubit c) => c.state.app.enableDynamicSearchbar,
    );
    final isFullscreen = context.select((FullscreenCubit f) => f.state);
    final showToolbar = context.select((ToolbarCubit t) => t.state);

    // ShortcusHost must be at the very root after the MaterialApp
    return ShortcutHost(
      rootFocusNode: _rootFocusNode,
      searchFocusNode: _searchbarFocusNode,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        //
        // Manages the stacks of windosw that may occur when opening
        // popups or secondary pages in the form of a window (e.g. settings menu)
        //
        body: WindowStackManagerWrapper(
          child: Column(
            children: [
              if (!isFullscreen) const Titlebar(child: Toolbar()),
              if (isFullscreen && showToolbar) const Toolbar(),
              //
              // Simulated classic desktop toolbar
              //
              //
              // HEADER
              // separated just to be organized,
              // pass here all required parameters
              //
              _AppHeader(
                searchbarFocusNode: _searchbarFocusNode,
                returnFocusToRoot: _returnFocusToRoot,
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
                            prev.referenceResult != curr.referenceResult,
                        listener: (context, state) {
                          final ref = state.referenceResult;
                          if (ref == null) return;

                          final BiblePaneEvent event =
                              switch (state.intentType) {
                            BSearchIntentType.gotoReference =>
                              BiblePaneDisplayChapter(
                                ref: ref,
                                source: IntentSource.searchbar,
                              ),
                            BSearchIntentType.gotoVerseNumber =>
                              BiblePaneJustChangeRef(
                                ref: ref,
                                source: IntentSource.searchbar,
                                saveHistory: true,
                              ),
                            BSearchIntentType.findByString =>
                              BiblePaneJustChangeRef(
                                ref: ref,
                              )
                          };

                          context
                              .read<PaneManagerCubit>()
                              .activeBloc()
                              .add(event);
                        },
                        child: MultipleBiblePanes(),
                      ),
                    ),
                    //
                    // Dynamic searchbar
                    //
                    if (enableDynamicSearchbar)
                      Positioned(
                        top: 20,
                        right: 0,
                        left: 0,
                        child: Visibility(
                          maintainFocusability: true,
                          maintainState: true,
                          visible: _searchbarHasFocus,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: BSearchbar(
                              focusNode: _searchbarFocusNode,
                              onSubmitted: () => _returnFocusToRoot(),
                              //onEditComplete: () => _returnFocusToRoot(),
                            ),
                          ),
                        ),
                      ),

                    if (isFullscreen && !showToolbar)
                      Positioned.fill(
                          child: Align(
                              alignment: AlignmentGeometry.topRight,
                              child: IconButton(
                                  tooltip: 'Help',
                                  onPressed: () {
                                    context
                                        .read<WindowStackManagerBloc>()
                                        .add(WindowStackManagerOpen(HelpWidget(
                                      onClose: () {
                                        context
                                            .read<WindowStackManagerBloc>()
                                            .add(WindowStackManagerClose());
                                      },
                                    )));
                                  },
                                  icon: Icon(Icons.help_outline_rounded)))),
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
    final alignment = context.select(
      (CustomizerCubit c) => c.state.app.searchbarPosition,
    );
    final isFullscreen = context.select((FullscreenCubit c) => c.state);
    final showToolbar = context.select((ToolbarCubit t) => t.state);
    final paneTheme = Theme.of(context).extension<BiblePaneTheme>()!;
    final enableDynamicSearchbar = context.select(
      (CustomizerCubit c) => c.state.app.enableDynamicSearchbar,
    );
    //final screen = MediaQuery.of(context)

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 12, vertical: enableDynamicSearchbar ? 0 : 8),
      child: Column(
        spacing: 18,
        children: [
          if (!enableDynamicSearchbar)
            Stack(
              children: [
                Row(
                  mainAxisAlignment: alignment == SearchbarPosition.center
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ThreeTapNavigator(),
                    BSearchbar(
                      focusNode: searchbarFocusNode,
                      onSubmitted: () => returnFocusToRoot(),
                      //onEditComplete: () => _returnFocusToRoot(),
                    ),
                    ShowHistoryButton(),
                    // SplitscreenControls(),
                    // BlocBuilder<FullscreenCubit, bool>(
                    //   builder: (context, isFullscreen) {
                    //     return IconButton(
                    //       onPressed: () =>
                    //           context.read<FullscreenCubit>().toggle(),
                    //       tooltip: isFullscreen
                    //           ? 'Exit fullscreen'
                    //           : 'Enter fullscreen',
                    //       icon: isFullscreen
                    //           ? const Icon(Icons.fullscreen_exit)
                    //           : const Icon(Icons.fullscreen),
                    //     );
                    //   },
                    // ),
                    // BlocBuilder<DisplayModeCubit, DisplayMode>(
                    //   builder: (context, dm) {
                    //     return IconButton(
                    //         tooltip: dm == DisplayMode.presentation
                    //             ? 'Exit presentation mode'
                    //             : 'Enter presentation mode',
                    //         onPressed: () {
                    //           if (dm == DisplayMode.presentation) {
                    //             context
                    //                 .read<DisplayModeCubit>()
                    //                 .set(DisplayMode.normal);
                    //           } else {
                    //             context
                    //                 .read<DisplayModeCubit>()
                    //                 .set(DisplayMode.presentation);
                    //           }
                    //         },
                    //         icon: Icon(Icons.fit_screen_rounded));
                    //   },
                    // ),
                  ],
                ),
                //
                // Show help button to avoid users getting stuck in fullscreen mode with hidden toolbar
                //
                if (isFullscreen && !showToolbar)
                  Positioned.fill(
                      child: Align(
                          alignment: AlignmentGeometry.centerRight,
                          child: IconButton(
                              tooltip: 'Help',
                              onPressed: () {
                                context
                                    .read<WindowStackManagerBloc>()
                                    .add(WindowStackManagerOpen(HelpWidget(
                                  onClose: () {
                                    context
                                        .read<WindowStackManagerBloc>()
                                        .add(WindowStackManagerClose());
                                  },
                                )));
                              },
                              icon: Icon(Icons.help_outline_rounded)))),
              ],
            ),
          //
          //
          //
          if (paneTheme.enableHangingRefs)
            Builder(builder: (context) {
              final activePaneBloc =
                  context.select((PaneManagerCubit pm) => pm.activeBloc());

              return BlocProvider.value(
                value: activePaneBloc,
                child: BlocBuilder<BiblePaneBloc, BiblePaneState>(
                  buildWhen: (prev, curr) => prev.reference != curr.reference,
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: enableDynamicSearchbar ? 18 : 0,
                        bottom: 18,
                      ),
                      child: Text(
                        state.reference.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: paneTheme.referenceFont,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 42,
                        ),
                      ),
                    );
                  },
                ),
              );
            })
        ],
      ),
    );
  }
}
