import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/three_tap_navigator/presentation/state/three_tap_navigator_cubit.dart';

import '../core/app_state/fullscreen_cubit.dart';
import '../core/app_state/interface_visibility_cubit.dart';
import '../features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../features/bible_installer_manager/presentation/state/installed_bibles/installed_bibles_bloc.dart';
import '../features/bible_searchbar/presentation/state/b_searchbar_bloc.dart';
import '../features/customizer/domain/entities/app_theme_settings.dart';
import '../features/customizer/presentation/models/bible_pane_general_theme.dart';
import '../features/customizer/presentation/models/bible_view_list_theme.dart';
import '../features/customizer/presentation/models/bible_view_presentation_theme.dart';
import '../features/customizer/presentation/state/customizer_cubit.dart';
import '../features/obs_live_overlay/presentation/state/obs_overlay/obs_live_overlay_cubit.dart';
import '../features/obs_live_overlay/presentation/state/obs_overlay_settinsg/obs_live_overlay_settings_cubit.dart';
import '../features/remote_controller/presentation/state/remote_controller/remote_controller_cubit.dart';
import '../features/remote_controller/presentation/state/remote_controller_settings/remote_controller_settings_cubit.dart';
import '../features/shortcuts/presentation/state/shortcuts_cubit.dart';
import '../features/window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import '../injection_container.dart' as di;
import 'app_shell.dart';

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
            builder: (context, child) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => di.sl<ObsLiveOverlayCubit>()),
                  BlocProvider(
                      create: (_) => di.sl<ObsLiveOverlaySettingsCubit>()),
                  BlocProvider(create: (_) => di.sl<MultiPaneManagerCubit>()),
                  BlocProvider(create: (_) => di.sl<FullscreenCubit>()..init()),
                  BlocProvider(create: (_) => di.sl<WindowStackManagerBloc>()),
                  BlocProvider(
                      create: (_) => di.sl<InstalledBiblesBloc>()
                        ..add(InstalledBiblesLoad())),
                  BlocProvider(create: (_) => di.sl<BSearchbarBloc>()),
                  BlocProvider(create: (_) => di.sl<RemoteControllerCubit>()),
                  BlocProvider(
                      create: (_) => di.sl<RemoteControllerSettingsCubit>()),
                  BlocProvider(create: (_) => di.sl<ShortcutsCubit>()),
                  BlocProvider(
                      create: (context) => di.sl<ThreeTapNavigatorCubit>()),
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
