// @dart=3.12
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection_container.dart' as di;
import '../core/infrastructure/window/app_window_manager.dart';
import '../core/lifecycle/app_lifecycle.dart';
import '../core/settings/settings_cubit.dart';
import '../features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../features/bible_display/settings/presentation/widgets/bible_view_settings_provider.dart';
import '../features/bible_searchbar/history/presentation/state/history_cubit.dart';
import '../features/bible_searchbar/search/presentation/state/search_bloc.dart';
import '../features/bible_searchbar/settings/search_settings.dart';
import '../features/my_library/settings/my_library_settings.dart';
import '../features/obs_live_overlay/presentation/state/obs_live_overlay_cubit.dart';
import '../features/obs_live_overlay/settings/overlay_settings.dart';
import '../features/remote_controller/presentation/state/remote_controller_cubit.dart';
import '../features/remote_controller/settings/remote_controller_settings.dart';
import '../features/shortcuts/presentation/state/shortcuts_cubit.dart';
import '../features/simple_presenter/presentation/cubit/presenter_cubit.dart';
import '../features/three_tap_navigator/presentation/state/three_tap_navigator_cubit.dart';
import '../shared/design_system/design_system.dart';
import 'app_shell.dart';
import 'settings/global_settings.dart';
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
    final canExit = await di.sl<AppLifecycleService>().onExitRequested();
    return canExit ? AppExitResponse.exit : AppExitResponse.cancel;
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // dart format off
      //
      // Bloc/Cubits provided with values means that they are immediatly instanciated.
      // Those provided with create means that they are created lazily.
      //
      providers: [
        // There is no reason to lazy load search feature
        // warm up this immediatly so there is no time wasted
        // on first search query
        BlocProvider.value(value: di.sl<SearchBloc>()),
        // Instanciated immediatly otherwise it doesn't start
        // registering historty entries at startup
        BlocProvider.value(value: di.sl<HistoryCubit>()),
        BlocProvider(create: (_) => di.sl<SettingsCubit<GlobalSettings>>()),
        BlocProvider(create: (_) => di.sl<SettingsCubit<MyLibrarySettings>>()),
        BlocProvider(create: (_) => di.sl<SettingsCubit<SearchSettings>>()),
        BlocProvider(create: (_) => di.sl<MultiPaneManagerCubit>()),
        BlocProvider(create: (_) => di.sl<ShortcutsCubit>()),
        BlocProvider(create: (_) => di.sl<ThreeTapNavigatorCubit>()),
        BlocProvider(create: (_) => di.sl<FullscreenCubit>()..init()),
        BlocProvider(create: (_) => di.sl<InterfaceVisibilityCubit>()),
        BlocProvider(create: (_) => di.sl<PresenterCubit>()),
        if (!kIsWeb) ...[
          BlocProvider(create: (_) => di.sl<ObsLiveOverlayCubit>()),
          BlocProvider(create: (_) => di.sl<SettingsCubit<OverlaySettings>>()),
          BlocProvider(create: (_) => di.sl<SettingsCubit<RemoteControllerSettings>>(),),
          BlocProvider(create: (_) => di.sl<RemoteControllerCubit>()),
        ],
      ],
      // dart format on
      child: BlocBuilder<SettingsCubit<GlobalSettings>, GlobalSettings>(
        builder: (context, state) {
          return BibleViewSettingsProvider(
            child: MaterialApp(
              title: 'Open Scripture',
              themeMode: state.mode,
              darkTheme: AppTheme.dark,
              theme: AppTheme.light,
              debugShowCheckedModeBanner: false,
              home: const AppShell(),
            ),
          );
        },
      ),
    );
  }
}
