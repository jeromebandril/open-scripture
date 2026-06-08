import 'package:get_it/get_it.dart';
import 'package:open_scripture/app/state/fullscreen_cubit.dart';
import 'package:open_scripture/app/state/interface_visibility_cubit.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/formats/osis_importer.dart';
// import 'package:open_scripture/core/di/init_common_features.dart';
// import 'package:open_scripture/core/di/init_features_desktop.dart'
//     if (dart.library.html) 'package:open_scripture/core/di/init_features_web.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/formats/usfx_importer.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/importer_registry.dart';
import 'package:open_scripture/core/engines/remote_controller/remote_command_router.dart';
import 'package:open_scripture/core/engines/settings/datasource/settings_datasource.dart';
import 'package:open_scripture/core/engines/settings/settings_repository.dart';
import 'package:open_scripture/core/infrastructure/database/daos/bible_content_dao.dart';
import 'package:open_scripture/core/infrastructure/database/daos/bible_installation_dao.dart';
import 'package:open_scripture/core/infrastructure/database/daos/installed_bibles_dao.dart';
import 'package:open_scripture/core/infrastructure/database/database.dart';
import 'package:open_scripture/core/infrastructure/event_bus/install_notifier.dart';
import 'package:open_scripture/core/infrastructure/event_bus/search_result_bus.dart';
import 'package:open_scripture/core/infrastructure/event_bus/resolved_search_intent_bus.dart';
import 'package:open_scripture/core/infrastructure/event_bus/selected_verse_bus.dart';
import 'package:open_scripture/core/infrastructure/window/app_window_manager.dart';
import 'package:open_scripture/core/sword/sword_bridge.dart';
import 'package:open_scripture/features/bible_display/bible_pane/data/repositories/bible_pane_repository_impl.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presentation/cubit/bible_selector_cubit.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/remote/pane_manager_handler.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/features/bible_importer/presentation/state/bible_importer_cubit.dart';
import 'package:open_scripture/features/bible_searchbar/history/presentation/cubit/history_cubit.dart';
import 'package:open_scripture/features/bible_searchbar/search/data/repositories/search_repository_impl.dart';
import 'package:open_scripture/features/bible_searchbar/search/domain/repositories/search_repository.dart';
import 'package:open_scripture/features/bible_searchbar/search/domain/search_intent_resolver.dart';
import 'package:open_scripture/features/bible_searchbar/search/presentation/remote/search_handler.dart';
import 'package:open_scripture/features/bible_searchbar/search/presentation/state/search_bloc.dart';
import 'package:open_scripture/features/customizer/data/datasources/customizer_datasource_desktop_impl.dart';
import 'package:open_scripture/features/customizer/data/repo/customizer_repo_impl.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/features/font_loader/presentation/state/font_loader_cubit.dart';
import 'package:open_scripture/features/my_library/presentation/cubit/my_library_cubit.dart';
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
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/local_bible_catalog_datasource_impl.dart';
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/sword_bible_catalog_datasource_impl.dart';
import 'package:open_scripture/shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import 'package:open_scripture/shared/data/datasources/bible_content_datasource/drift_bible_content_datasource_impl.dart';
import 'package:open_scripture/shared/data/datasources/bible_content_datasource/sword_bible_content_datasource_impl.dart';
import 'package:open_scripture/shared/data/datasources/drift_bible_installation_datasource_impl.dart';
import 'package:open_scripture/shared/data/datasources/drift_book_local_datasource_impl.dart';
import 'package:open_scripture/shared/data/repositories/bible_catalog_repository_impl.dart';
import 'package:open_scripture/shared/data/repositories/bible_content_repository_impl.dart';
import 'package:open_scripture/shared/data/repositories/bible_install_repository_impl.dart';
import 'package:open_scripture/shared/data/repositories/bible_pane_repository_factory_impl.dart';
import 'package:open_scripture/shared/data/repositories/drift_bible_book_repository_impl.dart';
import 'package:open_scripture/shared/domain/entities/bible_id.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/repositories/bible_pane_repository_factory.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';
import 'package:open_scripture/shared/utils/bible_ref_parser/bible_ref_parser.dart';
import 'package:open_scripture/shared/data/services/book_resolvers/chained_book_resolver.dart';
import 'package:open_scripture/shared/data/services/book_resolvers/drift_book_resolver.dart';
import 'package:open_scripture/shared/data/services/book_resolvers/programmatic_book_resolver.dart';
import 'package:open_scripture/shared/data/services/source_fetcher_service.dart';
import 'package:open_scripture/shared/domain/repositories/bible_book_repository.dart';
import 'package:open_scripture/shared/domain/repositories/bible_catalog_repository.dart';
import 'package:open_scripture/shared/domain/repositories/bible_content_repository.dart';
import 'package:open_scripture/shared/domain/repositories/bible_install_repository.dart';
import 'package:open_scripture/shared/domain/services/book_resolver.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // init sword bridge
  sl.registerLazySingleton(() => SwordBridge(),
      onCreated: (i) => i.init(r'C:\Users\jerom\sword'),
      dispose: (i) => i.shutdown());

  // init database
  sl.registerLazySingleton<AppDb>(() => AppDb());
  sl.registerLazySingleton<BibleContentDao>(() => BibleContentDao(sl()));
  sl.registerLazySingleton<InstalledBiblesDao>(() => InstalledBiblesDao(sl()));
  sl.registerLazySingleton<BibleInstallationDao>(
      () => BibleInstallationDao(sl()));

  // init datasources
  sl.registerLazySingleton<BibleCatalogDatasource>(
      () => LocalBibleCatalogDataSourceImpl(sl()),
      instanceName: 'local_drift');
  sl.registerLazySingleton<BibleCatalogDatasource>(
      () => SwordBibleCatalogDatasourceImpl(swordBridge: sl()),
      instanceName: 'local_sword');
  sl.registerLazySingleton<BibleContentDatasource>(
      () => DriftBibleContentDataSourceImpl(dao: sl()),
      instanceName: 'local_drift');
  sl.registerLazySingleton<BibleContentDatasource>(
      () => SwordBibleContentDatasourceImpl(swordBridge: sl()),
      instanceName: 'local_sword');
  sl.registerLazySingleton<BibleBookLocalDataSource>(
      () => DriftBibleBookLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<BibleInstallationDataSource>(
      () => DriftBibleInstallationDataSourceImpl(sl()));

  // init repositories
  sl.registerLazySingleton<BibleBookRepository>(
      () => BibleBookRepositoryImpl(sl()));
  sl.registerLazySingleton<BibleCatalogRepository>(
      () => BibleCatalogRepositoryImpl(
          sl.get<BibleCatalogDatasource>(instanceName: 'local_drift')),
      instanceName: 'local_drift');
  sl.registerLazySingleton<BibleCatalogRepository>(
      () => BibleCatalogRepositoryImpl(
          sl.get<BibleCatalogDatasource>(instanceName: 'local_sword')),
      instanceName: 'local_sword');
  sl.registerLazySingleton<BibleContentRepository>(
      () => BibleContentRepositoryImpl(sl()));
  sl.registerLazySingleton<BibleInstallRepository>(
      () => BibleInstallRepositoryImpl(sl(), sl(), sl()));

  // Bible Pane
  sl.registerLazySingleton<BiblePaneRepository>(
      () => BiblePaneRepositoryImpl(
          contentDatasource: sl.get(instanceName: 'local_drift'),
          catalogDatasource:
              sl.get<BibleCatalogDatasource>(instanceName: 'local_drift')),
      instanceName: 'local_drift');
  sl.registerLazySingleton<BiblePaneRepository>(
      () => BiblePaneRepositoryImpl(
          contentDatasource: sl.get(instanceName: 'local_sword'),
          catalogDatasource:
              sl.get<BibleCatalogDatasource>(instanceName: 'local_sword')),
      instanceName: 'local_sword');
  sl.registerLazySingleton<BibleRepositoryFactory>(
    () => BibleRepositoryFactoryImpl({
      BibleRepositoryType.installed: () =>
          sl.get<BiblePaneRepository>(instanceName: 'local_drift'),
      BibleRepositoryType.sword: () =>
          sl.get<BiblePaneRepository>(instanceName: 'local_sword'),
    }),
  );
  sl.registerFactoryParam<BiblePaneBloc, int, void>(
    (paneId, _) => BiblePaneBloc(
      repositoryFactory: sl<BibleRepositoryFactory>(),
      paneId: paneId,
      navBus: sl.isRegistered<SearchResultBus>() ? sl<SearchResultBus>() : null,
      notifier:
          sl.isRegistered<SelectedVerseBus>() ? sl<SelectedVerseBus>() : null,
    ),
  );

  // init bible compiler
  sl.registerLazySingleton<ImporterRegistry>(
    () => ImporterRegistry([UsfxImporter(), OsisImporter()]),
  );
  sl.registerLazySingleton<SourceFetcherService>(
    () => SourceFetcherServiceImpl(),
  );

  // init book resolver
  sl.registerLazySingleton<BookResolver>(() => ChainedBookResolver([
        DriftBookResolver(sl()),
        ProgrammaticIdResolver(),
      ]));

  // init bible ref parser
  sl.registerLazySingleton<BibleRefParser>(() => BibleRefParser());

  // init globals
  sl.registerLazySingleton(() => SearchResultBus());
  sl.registerLazySingleton(() => ResolvedSearchIntentBus());
  sl.registerLazySingleton(() => InstallNotifier());
  sl.registerLazySingleton<AppWindowManager>(() => WindowManagerImpl());
  sl.registerLazySingleton(() => FullscreenCubit(sl<AppWindowManager>()));
  sl.registerFactory(() => TextScalerCubit());
  sl.registerFactory(() => FontLoaderCubit());
  sl.registerLazySingleton(() => InterfaceVisibilityCubit());

  // init bible features

  // init multipane
  sl.registerLazySingleton<MultiPaneManagerCubit>(() => MultiPaneManagerCubit(
      searchIntentBus: sl(), bookResolver: sl(), searchResultBus: sl()));

  // init customizer
  sl.registerLazySingleton<SettingsDatasource<CustomizerState>>(
    () => CustomizerDatasourceImpl(),
  );
  sl.registerLazySingleton<SettingsRepository<CustomizerState>>(
    () => CustomizerRepoImpl(localDatasource: sl()),
  );
  sl.registerFactory(() => CustomizerCubit(repo: sl()));

  // init windows tack manager
  sl.registerFactory(() => WindowStackManagerBloc());

  sl.registerFactoryParam<BibleSelectorCubit, List<BibleId>,
      BibleRepositoryType>((selectedIds,
          repoType) =>
      BibleSelectorCubit(selectedBiblesIds: selectedIds, repoType: repoType));

  //
  sl.registerLazySingleton(
    () => AppCommandDispatcher(
      paneManagerCubit: sl<MultiPaneManagerCubit>(),
      searchbarBloc: sl<SearchBloc>(),
      fullscreenCubit: sl<FullscreenCubit>(),
      interfaceVisibilityCubit: sl<InterfaceVisibilityCubit>(),
    ),
  );
  sl.registerLazySingleton<ShortcutsRepo>(
    () => ShortcutsRepoImpl(dispatcher: sl()),
  );
  sl.registerLazySingleton(() => ShortcutsCubit(repo: sl()));

  // search

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(parser: sl()),
  );
  sl.registerLazySingleton(() => SearchIntentResolver());
  sl.registerLazySingleton<HistoryCubit>(() => HistoryCubit(navBus: sl()));
  sl.registerLazySingleton<SearchBloc>(
    () => SearchBloc(
        repo: sl(),
        intentResolver: sl(),
        searchIntentBus: sl(),
        searchResultBus: sl()),
  );

  // My Library
  sl.registerLazySingleton<MyLibraryCubit>(
      () => MyLibraryCubit(
          repo: sl.get<BibleCatalogRepository>(instanceName: 'local_drift'),
          notifier: sl(),
          installRepo: sl()),
      instanceName: 'local_drift',
      onCreated: (c) => c.getBibles());
  sl.registerLazySingleton<MyLibraryCubit>(
      () => MyLibraryCubit(
          repo: sl.get<BibleCatalogRepository>(instanceName: 'local_sword'),
          notifier: sl(),
          installRepo: null),
      instanceName: 'local_sword',
      onCreated: (c) => c.getBibles());

  // REmote controller
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
        'search_bar': SearchBarHandler(bloc: sl<SearchBloc>()),
        'pane': PaneManagerHandler(
          multiPaneManagerCubit: sl<MultiPaneManagerCubit>(),
          myLibraryCubit: sl.get<MyLibraryCubit>(instanceName: 'local_drift'),
        ),
      },
    ),
  );
  sl.registerLazySingleton<RemoteControllerRepo>(
    () => RemoteControllerRepoImpl(wsServer: sl(), router: sl()),
  );
  sl.registerFactory(
    () => RemoteControllerCubit(repo: sl(), dispatcher: sl()),
  );

  // obs
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

  // Importer
  sl.registerFactory(() => BibleImporterCubit(repo: sl(), notifier: sl()));

  // Three tap nav

  sl.registerLazySingleton<ThreeTapNavigatorRepository>(
    () => ThreeTapNavigatorRepositoryImpl(
        contentDataSource: sl.get(instanceName: 'local_drift'),
        booksLocalDataSource: sl()),
  );
  sl.registerLazySingleton(() => ThreeTapNavigatorCubit(repo: sl()));
}

/// Registers all dependencies in the correct order:
/// infrastructure -> app state -> features (leaves first, composites last).
// Future<void> init() async {
//   initCommonFeatures();

//   initPlatformSpecificFeatures();
// }

// Overview

// // 1. Database - no dependencies
// initDatabase();
// // 2. Installer engine - depends on database indirectly via datasources
// initInstaller();
// // 3. Core datasources - depend on database + installer
// initInfrastructure();
// // 4. Global app state & event buses - no feature dependencies
// initAppState();
// // 5. Features - registered leaves-first so composite features
// //   (shortcuts, remotecontroller) can safely resolve their deps.
// initMyLibraryFeature();
// initCustomizerFeature();
// initBibleInstallManagerFeature();
// initWindowStackFeature();
// initBSearchbarFeature();
// initBibleSelectorFeature();
// initReaderFeature();
// initBibleImporterFeature();
// initThreeTapNavFeature();
// initObsLiveOverlayFeature();
// initRemoteControllerFeature();
// initSplitScreenFeature();
// // Last - depends on PaneManagerCubit, BSearchbarBloc, and most app state
// initShortcutFeature();
