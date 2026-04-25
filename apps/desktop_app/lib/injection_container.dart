import 'package:get_it/get_it.dart';
import 'package:open_scripture/core/app_state/fullscreen_cubit.dart';
import 'package:open_scripture/core/app_state/history_visibility_cubit.dart';
import 'package:open_scripture/core/app_state/menubar_visibility_cubit.dart';
import 'package:open_scripture/core/app_state/toolbar_cubit.dart';
import 'package:open_scripture/core/infrastructure/bible_data/bible_local_datasource.dart';
import 'package:open_scripture/core/infrastructure/bible_data/bible_remote_datasource.dart';
import 'package:open_scripture/core/infrastructure/database/database.dart';
import 'package:open_scripture/core/infrastructure/event_bus/install_notifier.dart';
import 'package:open_scripture/core/infrastructure/event_bus/navigation_bus.dart';
import 'package:open_scripture/core/infrastructure/event_bus/resolved_search_intent_bus.dart';
import 'package:open_scripture/core/infrastructure/event_bus/selected_verse_bus.dart';
import 'package:open_scripture/core/systems/installer/bible/import/formats/osis_importer.dart';
import 'package:open_scripture/core/systems/installer/bible/import/formats/usfx_importer.dart';
import 'package:open_scripture/core/systems/installer/bible/import/importer_registry.dart';
import 'package:open_scripture/core/systems/installer/bible/source/packages/source_package_factory.dart';
import 'package:open_scripture/core/systems/remote_controller/remote_command_router.dart';
import 'package:open_scripture/core/systems/settings/settings_datasource.dart';
import 'package:open_scripture/core/systems/settings/settings_repository.dart';
import 'package:open_scripture/features/bible_searchbar/domain/search_intent_resolver.dart';
import 'package:open_scripture/shared/entities/book_names.dart';
import 'package:open_scripture/shared/utils/bible_ref_parser/bible_ref_parser.dart';
import 'package:open_scripture/features/bible_searchbar/data/repositories/b_searchbar_repository_impl.dart';
import 'package:open_scripture/features/bible_searchbar/domain/searchbar_repository.dart';
import 'package:open_scripture/features/bible_searchbar/presentation/remote/b_searchbar_handler.dart';
import 'package:open_scripture/features/bible_searchbar/presentation/state/b_searchbar_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/data/repositories/bible_pane_repository_impl.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import 'package:open_scripture/features/bible_display/bible_selector/data/repositories/bible_selector_repository_impl.dart';
import 'package:open_scripture/features/bible_display/bible_selector/domain/repositories/bible_selector_repository.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presentation/state/bible_selector_bloc.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/remote/multi_pane_manager_handler.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/features/bible_importer/data/repository/bible_importer_repo_impl.dart';
import 'package:open_scripture/features/bible_importer/domain/repository/bible_importer_repo.dart';
import 'package:open_scripture/features/bible_importer/presentation/state/bible_importer_cubit.dart';
import 'package:open_scripture/features/bible_installer_manager/data/repositories/bible_manager_repository_impl.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/repositories/bible_manager_repository.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/state/download_manager/bloc/download_manager_bloc.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/state/installed_bibles/installed_bibles_bloc.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/state/remote_catalog/remote_catalog_bloc.dart';
import 'package:open_scripture/features/customizer/data/datasources/customizer_datasource.dart';
import 'package:open_scripture/features/customizer/data/repo/customizer_repo_impl.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/features/font_loader/presentation/state/font_loader_cubit.dart';
import 'package:open_scripture/features/obs_live_overlay/data/datasource/overlay_file_system.dart';
import 'package:open_scripture/features/obs_live_overlay/data/datasource/overlay_server_manager.dart';
import 'package:open_scripture/features/obs_live_overlay/data/datasource/overlay_settings_datasource.dart';
import 'package:open_scripture/features/obs_live_overlay/data/repository/overlay_repository_impl.dart';
import 'package:open_scripture/features/obs_live_overlay/data/repository/overlay_settings_repo_impl.dart';
import 'package:open_scripture/features/obs_live_overlay/domain/entities/overlay_settings.dart';
import 'package:open_scripture/features/obs_live_overlay/domain/repostiory/overlay_repository.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/state/obs_overlay/obs_live_overlay_cubit.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/state/obs_overlay_settinsg/obs_live_overlay_settings_cubit.dart';
import 'package:open_scripture/features/remote_controller/data/datasource/remote_controller_settings_datasource.dart';
import 'package:open_scripture/features/remote_controller/data/datasource/remote_controller_ws.dart';
import 'package:open_scripture/features/remote_controller/data/repositories/remote_controller_repo_impl.dart';
import 'package:open_scripture/features/remote_controller/data/repositories/remote_controller_settings_repo_impl.dart';
import 'package:open_scripture/features/remote_controller/domain/entities/remote_controller_settings.dart';
import 'package:open_scripture/features/remote_controller/domain/repositories/remote_controller_repo.dart';
import 'package:open_scripture/features/remote_controller/presentation/state/remote_controller/remote_controller_cubit.dart';
import 'package:open_scripture/features/remote_controller/presentation/state/remote_controller_settings/remote_controller_settings_cubit.dart';
import 'package:open_scripture/features/shortcuts/data/repositories/shortcuts_repo_impl.dart';
import 'package:open_scripture/features/shortcuts/domain/repositories/shortcuts_repo.dart';
import 'package:open_scripture/features/shortcuts/presentation/models/app_command_dispatcher.dart';
import 'package:open_scripture/features/shortcuts/presentation/state/shortcuts_cubit.dart';
import 'package:open_scripture/features/text_scaler/presentation/state/text_scaler_cubit.dart';
import 'package:open_scripture/features/three_tap_navigator/data/repository/three_tap_navigator_repository_impl.dart';
import 'package:open_scripture/features/three_tap_navigator/domain/repository/three_tap_navigator_repository.dart';
import 'package:open_scripture/features/three_tap_navigator/presentation/state/three_tap_navigator_cubit.dart';
import 'package:open_scripture/features/window_stack_manager/presentation/state/window_stack_manager_bloc.dart';

final sl = GetIt.instance;

/// Registers all dependencies in the correct order:
/// infrastructure -> app state -> features (leaves first, composites last).
Future<void> init() async {
  // 1. Database - no dependencies
  _initDatabase();

  // 2. Installer engine - depends on database indirectly via datasources
  _initInstaller();

  // 3. Core datasources - depend on database + installer
  _initInfrastructure();

  // 4. Global app state & event buses - no feature dependencies
  _initAppState();

  // 5. Features - registered leaves-first so composite features
  //   (shortcuts, remote_controller) can safely resolve their deps.
  _initCustomizerFeature();
  _initBibleManagerFeature();
  _initWindowStackFeature();
  _initBSearchbarFeature();
  _initBibleSelectorFeature();
  _initReaderFeature();
  _initBibleImporterFeature();
  _initThreeTapNavFeature();
  _initObsLiveOverlayFeature();
  _initRemoteControllerFeature();
  _initSplitScreenFeature();

  // Last - depends on PaneManagerCubit, BSearchbarBloc, and most app state
  _initShortcutFeature();
}

// ---------------------------------------------------------------------------
// Infrastructure
// ---------------------------------------------------------------------------

void _initDatabase() {
  sl.registerLazySingleton<AppDb>(() => AppDb());
}

void _initInstaller() {
  sl.registerLazySingleton<UsfxImporter>(() => UsfxImporter());
  sl.registerLazySingleton<OsisImporter>(() => OsisImporter());
  sl.registerLazySingleton<ImporterRegistry>(
    () => ImporterRegistry([sl<UsfxImporter>(), sl<OsisImporter>()]),
  );
  sl.registerLazySingleton<SourcePackageFactory>(
    () => const SourcePackageFactory(),
  );
}

void _initInfrastructure() {
  sl.registerLazySingleton<BibleLocalDataSource>(
    () => BibleLocalDatasourceImpl(
      db: sl(),
      importerRegistry: sl(),
      sourcePackageFactory: sl(),
    ),
  );
  sl.registerLazySingleton<BibleRemoteDataSource>(
    () => BibleRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<BibleRefResolver>(
    () => BibleRefResolver(versification: Versification.allSupported),
  );
}

// ---------------------------------------------------------------------------
// App-wide state & event buses
// ---------------------------------------------------------------------------

void _initAppState() {
  sl.registerLazySingleton(() => NavigationBus());
  sl.registerLazySingleton(() => ResolvedSearchIntentBus());
  sl.registerLazySingleton(() => InstallNotifier());
  sl.registerLazySingleton(() => MenubarCubit());
  sl.registerLazySingleton(() => ToolbarCubit());
  sl.registerLazySingleton(() => FullscreenCubit());
  sl.registerLazySingleton(() => HistoryVisibilityCubit());
  sl.registerFactory(() => TextScalerCubit());
  sl.registerFactory(() => FontLoaderCubit());
}

// ---------------------------------------------------------------------------
// Features
// ---------------------------------------------------------------------------

void _initCustomizerFeature() {
  sl.registerLazySingleton<SettingsDatasource<CustomizerState>>(
    () => CustomizerDatasourceImpl(),
  );
  sl.registerLazySingleton<SettingsRepository<CustomizerState>>(
    () => CustomizerRepoImpl(localDatasource: sl()),
  );
  sl.registerFactory(() => CustomizerCubit(repo: sl()));
}

void _initBibleManagerFeature() {
  sl.registerLazySingleton<BibleManagerRepository>(
    () => BibleManagerRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );
  sl.registerFactory(() => DownloadManagerBloc(repo: sl(), notifier: sl()));
  sl.registerFactory(() => RemoteCatalogBloc(repository: sl()));
  sl.registerFactory(
      () => InstalledBiblesBloc(repository: sl(), notifier: sl()));
}

void _initWindowStackFeature() {
  sl.registerFactory(() => WindowStackManagerBloc());
}

void _initBSearchbarFeature() {
  sl.registerLazySingleton<BSearchbarRepository>(
    () => BSearchbarRepositoryImpl(
      parser: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton(() => SearchIntentResolver());
  // Singleton because it is never disposed and is referenced by remote handlers
  sl.registerLazySingleton<BSearchbarBloc>(
    () => BSearchbarBloc(
        repo: sl(), navBus: sl(), resolver: sl(), searchIntentBus: sl()),
  );
}

void _initBibleSelectorFeature() {
  sl.registerLazySingleton<BibleSelectorRepository>(
    () => BibleSelectorRepositoryImpl(localDatasource: sl()),
  );
  sl.registerFactory(() => BibleSelectorBloc(repo: sl()));
}

void _initReaderFeature() {
  sl.registerLazySingleton<BiblePaneRepository>(
    () => BiblePaneRepositoryImpl(localDatasource: sl()),
  );
  sl.registerLazySingleton(() => BibleReferenceParser(resolver: sl()));
}

void _initBibleImporterFeature() {
  sl.registerLazySingleton<BibleImporterRepo>(
    () => BibleImporterRepoImpl(localDataSource: sl()),
  );
  sl.registerFactory(() => BibleImporterCubit(repo: sl(), notifier: sl()));
}

void _initThreeTapNavFeature() {
  sl.registerLazySingleton<ThreeTapNavigatorRepository>(
    () => ThreeTapNavigatorRepositoryImpl(localDataSource: sl()),
  );
  sl.registerFactory(() => ThreeTapNavigatorCubit(repo: sl()));
}

void _initObsLiveOverlayFeature() {
  sl.registerLazySingleton<SettingsDatasource<OverlaySettings>>(
    () => OverlaySettingsDatasourceImpl(),
  );
  sl.registerLazySingleton<SettingsRepository<OverlaySettings>>(
    () => OverlaySettingsRepoImpl(localDatasource: sl()),
  );
  sl.registerFactory(() => ObsLiveOverlaySettingsCubit(repo: sl()));

  sl.registerLazySingleton<SelectedVerseBus>(
    () => SelectedVerseBus(),
  );
  sl.registerLazySingleton<OverlayFilesystem>(() => OverlayFilesystem());
  sl.registerLazySingleton<OverlayServerManager>(
    () => OverlayServerManager(fs: sl()),
  );
  sl.registerLazySingleton<OverlayRepository>(
    () => OverlayRepositoryImpl(mgr: sl()),
  );
  sl.registerFactory(() => ObsLiveOverlayCubit(repo: sl(), notifier: sl()));
}

void _initRemoteControllerFeature() {
  sl.registerLazySingleton<SettingsDatasource<RemoteControllerSettings>>(
    () => RemoteControllerSettingsDatasource(),
  );
  sl.registerLazySingleton<SettingsRepository<RemoteControllerSettings>>(
    () => RemoteControllerSettingsRepoImpl(localDatasource: sl()),
  );
  sl.registerFactory(() => RemoteControllerSettingsCubit(repo: sl()));

  sl.registerLazySingleton(() => RemoteControllerWSServer());
  sl.registerLazySingleton(
    () => RemoteCommandRouter(
      handlers: {
        'search_bar': SearchBarHandler(bloc: sl<BSearchbarBloc>()),
        'pane': PaneManagerHandler(bloc: sl<MultiPaneManagerCubit>()),
      },
    ),
  );
  sl.registerLazySingleton<RemoteControllerRepo>(
    () => RemoteControllerRepoImpl(wsServer: sl(), router: sl()),
  );
  sl.registerFactory(
    () => RemoteControllerCubit(repo: sl(), dispatcher: sl()),
  );
}

void _initSplitScreenFeature() {
  sl.registerLazySingleton<MultiPaneManagerCubit>(
    () => MultiPaneManagerCubit(repo: sl(), searchIntentBus: sl()),
  );
}

void _initShortcutFeature() {
  sl.registerLazySingleton(
    () => AppCommandDispatcher(
      paneManagerCubit: sl<MultiPaneManagerCubit>(),
      searchbarBloc: sl<BSearchbarBloc>(),
      historyVisibilityCubit: sl<HistoryVisibilityCubit>(),
      toolbarCubit: sl<ToolbarCubit>(),
      menubarCubit: sl<MenubarCubit>(),
      fullscreenCubit: sl<FullscreenCubit>(),
    ),
  );
  sl.registerLazySingleton<ShortcutsRepo>(
    () => ShortcutsRepoImpl(dispatcher: sl()),
  );
  sl.registerLazySingleton(() => ShortcutsCubit(repo: sl()));
}
