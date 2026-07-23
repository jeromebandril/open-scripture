import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection_container.dart' as di;
import '../core/infrastructure/window/app_window_manager.dart';
import '../core/lifecycle/app_lifecycle.dart';
import '../features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../features/bible_searchbar/history/presentation/state/history_cubit.dart';
import '../features/bible_searchbar/search/presentation/state/search_bloc.dart';
import '../features/customizer/presentation/models/bible_pane_general_theme.dart';
import '../features/customizer/presentation/models/bible_view_list_theme.dart';
import '../features/customizer/presentation/models/bible_view_presentation_theme.dart';
import '../features/customizer/presentation/state/customizer_cubit.dart';
import '../features/my_library/settings/my_library_settings_cubit.dart';
import '../features/obs_live_overlay/presentation/state/obs_live_overlay_cubit.dart';
import '../features/obs_live_overlay/settings/obs_live_overlay_settings_cubit.dart';
import '../features/remote_controller/presentation/state/remote_controller_cubit.dart';
import '../features/remote_controller/settings/remote_controller_settings_cubit.dart';
import '../features/shortcuts/presentation/state/shortcuts_cubit.dart';
import '../features/three_tap_navigator/presentation/state/three_tap_navigator_cubit.dart';
import '../features/window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import '../shared/design_system/design_system.dart';
import 'app_shell.dart';
import 'state/fullscreen_cubit.dart';
import 'state/interface_visibility_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();

    // TODO: maybe I can place this in AppLifeCycle.onStartup()
    di.sl<AppWindowManager>().toggleExitGuard(true);

    _lifecycleListener = AppLifecycleListener(
      onExitRequested: _handleExitRequested,
    );
  }

  Future<AppExitResponse> _handleExitRequested() async {
    try {
      final canExit = await di.sl<AppLifecycleService>().onExitRequested();
      return canExit ? AppExitResponse.exit : AppExitResponse.cancel;
    } catch (e) {
      print("Error during shutdown: $e");
    }
    return AppExitResponse.exit;
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

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
          // final enableTint = false; //state.app.enableAutoColorScheme;
          // final accentColor = state.app.accentColor;

          final extensions = <ThemeExtension<dynamic>>[
            state.pane
                .toExtension()
                .copyWith(accentColor: state.app.accentColor),
            state.presentTheme.toExtension(),
            state.listTheme.toExtension(),
          ];

          final light = AppTheme.light.copyWith(
              // colorScheme: enableTint
              //     ? ColorScheme.fromSeed(seedColor: accentColor)
              //     : null,
              extensions: extensions);
          final dark = AppTheme.dark.copyWith(
              // colorScheme: enableTint
              //     ? ColorScheme.fromSeed(seedColor: accentColor)
              //     : null,
              extensions: extensions);

          return MaterialApp(
            title: 'Open Scripture',
            themeMode: state.app.mode,
            darkTheme: dark,
            theme: light,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return MultiBlocProvider(
                providers: [
                  if (!kIsWeb) ...[
                    BlocProvider(create: (_) => di.sl<ObsLiveOverlayCubit>()),
                    BlocProvider(
                        create: (_) => di.sl<ObsLiveOverlaySettingsCubit>()),
                    BlocProvider(
                        create: (_) => di.sl<RemoteControllerSettingsCubit>()),
                    BlocProvider(create: (_) => di.sl<RemoteControllerCubit>()),
                    // BlocProvider(create: (_) => di.sl<InstallerBloc>()),
                  ],
                  BlocProvider.value(value: di.sl<MyLibrarySettingsCubit>()),
                  BlocProvider(
                      create: (context) => di.sl<ThreeTapNavigatorCubit>()),
                  BlocProvider.value(value: di.sl<MultiPaneManagerCubit>()),
                  BlocProvider(create: (_) => di.sl<FullscreenCubit>()..init()),
                  BlocProvider(create: (_) => di.sl<WindowStackManagerBloc>()),
                  BlocProvider.value(value: di.sl<SearchBloc>()),
                  BlocProvider.value(value: di.sl<HistoryCubit>()),
                  BlocProvider.value(value: di.sl<ShortcutsCubit>()),
                  BlocProvider(
                      create: (context) => di.sl<InterfaceVisibilityCubit>()),
                ],
                child: child!,
              );
            },
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
