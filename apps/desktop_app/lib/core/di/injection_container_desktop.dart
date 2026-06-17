// @dart=3.12
import 'package:get_it/get_it.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/formats/osis_importer.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/formats/usfx_importer.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/importer_registry.dart';
import 'package:open_scripture/core/engines/remote_controller/remote_command_router.dart';
import 'package:open_scripture/core/engines/settings/datasource/settings_datasource.dart';
import 'package:open_scripture/core/engines/settings/settings_repository.dart';
import 'package:open_scripture/core/infrastructure/database/daos/bible_content_dao.dart';
import 'package:open_scripture/core/infrastructure/database/daos/bible_installation_dao.dart';
import 'package:open_scripture/core/infrastructure/database/daos/installed_bibles_dao.dart';
import 'package:open_scripture/core/infrastructure/database/database.dart';
import 'package:open_scripture/core/infrastructure/event_bus/selected_verse_bus.dart';
import 'package:open_scripture/core/lifecycle/app_lifecycle.dart';
import 'package:open_scripture/core/lifecycle/app_lifecycle_desktop_impl.dart';
import 'package:open_scripture/core/sword/sword_bridge.dart';
import 'package:open_scripture/features/bible_display/bible_pane/data/repositories/bible_pane_repository_impl.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/remote/pane_manager_handler.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/features/bible_importer/data/datasources/bible_importer_settings_datasource.dart';
import 'package:open_scripture/features/bible_importer/data/repositories/bible_importer_settings_repository_impl.dart';
import 'package:open_scripture/features/bible_importer/domain/entities/bible_importer_settings.dart';
import 'package:open_scripture/features/bible_importer/presentation/state/bible_importer_cubit/bible_importer_cubit.dart';
import 'package:open_scripture/features/bible_importer/presentation/state/bible_importer_settings_cubit/bible_importer_settings_cubit.dart';
import 'package:open_scripture/features/bible_searchbar/search/presentation/remote/search_handler.dart';
import 'package:open_scripture/features/bible_searchbar/search/presentation/state/search_bloc.dart';
import 'package:open_scripture/features/customizer/data/datasources/customizer_datasource_desktop_impl.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
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
import 'package:open_scripture/features/three_tap_navigator/data/repository/three_tap_navigator_repository_impl.dart';
import 'package:open_scripture/features/three_tap_navigator/domain/repository/three_tap_navigator_repository.dart';
import 'package:open_scripture/features/three_tap_navigator/presentation/state/three_tap_navigator_cubit.dart';
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/local_bible_catalog_datasource_impl.dart';
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/sword_bible_catalog_datasource_impl.dart';
import 'package:open_scripture/shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import 'package:open_scripture/shared/data/datasources/bible_content_datasource/drift_bible_content_datasource_impl.dart';
import 'package:open_scripture/shared/data/datasources/bible_content_datasource/sword_bible_content_datasource_impl.dart';
import 'package:open_scripture/shared/data/datasources/bible_installation_datasource/drift_bible_installation_datasource_impl.dart';
import 'package:open_scripture/shared/data/datasources/bible_installation_datasource/sword_bible_installation_datasource_impl.dart';
import 'package:open_scripture/shared/data/datasources/drift_book_local_datasource_impl.dart';
import 'package:open_scripture/shared/data/repositories/bible_catalog_repository_impl.dart';
import 'package:open_scripture/shared/data/repositories/bible_install_repository_impl.dart';
import 'package:open_scripture/shared/data/repositories/bible_pane_repository_factory_impl.dart';
import 'package:open_scripture/shared/data/repositories/drift_bible_book_repository_impl.dart';
import 'package:open_scripture/shared/data/services/bible_importer_settings_service_impl.dart';
import 'package:open_scripture/shared/data/services/bible_installer_strategy/canonical_bible_installer_strategy.dart';
import 'package:open_scripture/shared/data/services/bible_installer_strategy/sword_bible_installer_strategy.dart';
import 'package:open_scripture/shared/domain/repositories/bible_pane_repository_factory.dart';
import 'package:open_scripture/shared/domain/services/bible_importer_settings_service.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';
import 'package:open_scripture/shared/data/services/book_resolvers/chained_book_resolver.dart';
import 'package:open_scripture/shared/data/services/book_resolvers/drift_book_resolver.dart';
import 'package:open_scripture/shared/data/services/book_resolvers/programmatic_book_resolver.dart';
import 'package:open_scripture/shared/data/services/source_fetcher_service.dart';
import 'package:open_scripture/shared/domain/repositories/bible_book_repository.dart';
import 'package:open_scripture/shared/domain/repositories/bible_catalog_repository.dart';
import 'package:open_scripture/shared/domain/repositories/bible_install_repository.dart';
import 'package:open_scripture/shared/domain/services/book_resolver.dart';

// dart format off

Future<void> init(GetIt sl) async {
  sl.registerLazySingleton<AppLifecycleService>(
    () => DesktopAppLifecycleService(bridge: sl<SwordBridge>()),
  );

  // Database
  sl.registerLazySingleton<AppDb>(() => AppDb());
  sl.registerLazySingleton<BibleContentDao>(() => BibleContentDao(sl()));
  sl.registerLazySingleton<InstalledBiblesDao>(() => InstalledBiblesDao(sl()));
  sl.registerLazySingleton<BibleInstallationDao>(() => BibleInstallationDao(sl()),);

  // Datasources
  sl.registerLazySingleton<BibleCatalogDatasource>(() => 
    LocalBibleCatalogDataSourceImpl(sl()),
    instanceName: BibleRepositoryType.localDatabase.name,
  );
  sl.registerLazySingleton<BibleContentDatasource>(() => 
    DriftBibleContentDataSourceImpl(dao: sl()),
    instanceName: BibleRepositoryType.localDatabase.name,
  );
  sl.registerLazySingleton<BibleCatalogDatasource>(() => 
    SwordBibleCatalogDatasourceImpl(swordBridge: sl()),
    instanceName: BibleRepositoryType.sword.name,
  );
  sl.registerLazySingleton<BibleContentDatasource>(() => 
    SwordBibleContentDatasourceImpl(swordBridge: sl()),
    instanceName: BibleRepositoryType.sword.name,
  );
  sl.registerLazySingleton<BibleBookLocalDataSource>(() => DriftBibleBookLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<BibleInstallationDataSource>(() => DriftBibleInstallationDataSourceImpl(sl()));
  sl.registerLazySingleton<SwordInstallationDatasource>(() => SwordBibleInstallationDatasourceImpl(swordBridge: sl()));

  // init repositories
  sl.registerLazySingleton<BibleBookRepository>(() => BibleBookRepositoryImpl(sl()));
  sl.registerLazySingleton<BibleCatalogRepository>(
    () => BibleCatalogRepositoryImpl(
      sl.get<BibleCatalogDatasource>(instanceName: BibleRepositoryType.localDatabase.name),
    ),
    instanceName: BibleRepositoryType.localDatabase.name,
  );
  sl.registerLazySingleton<BibleCatalogRepository>(
    () => BibleCatalogRepositoryImpl(
      sl.get<BibleCatalogDatasource>(instanceName: BibleRepositoryType.sword.name),
    ),
    instanceName: BibleRepositoryType.sword.name,
  );

  // Install strategies
  sl.registerLazySingleton<CanonicalInstallerStrategy>(
    () => CanonicalInstallerStrategy(
      fetcher: sl(),
      compiler: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<SwordInstallerStrategy>(
    () => SwordInstallerStrategy(
      fetcher: sl(),
      localDatasource: sl(),
      settingsService: sl(),
    ),
  );
  sl.registerLazySingleton<BibleInstallRepository>(
    () => BibleInstallRepositoryImpl({
      BibleRepositoryType.localDatabase: sl<CanonicalInstallerStrategy>(),
      BibleRepositoryType.sword: sl<SwordInstallerStrategy>(),
    }),
  );

  // Bible Pane
  // repositories
  sl.registerLazySingleton<BiblePaneRepository>(
    () => BiblePaneRepositoryImpl(
      contentDatasource: sl.get(instanceName: BibleRepositoryType.localDatabase.name),
      catalogDatasource: sl.get<BibleCatalogDatasource>(instanceName: BibleRepositoryType.localDatabase.name),
    ),
    instanceName: BibleRepositoryType.localDatabase.name,
  );
  sl.registerLazySingleton<BiblePaneRepository>(
    () => BiblePaneRepositoryImpl(
      contentDatasource: sl.get(instanceName: BibleRepositoryType.sword.name),
      catalogDatasource: sl.get<BibleCatalogDatasource>(instanceName: BibleRepositoryType.sword.name),
    ),
    instanceName: BibleRepositoryType.sword.name,
  );
  // repository factoryu
  sl.registerLazySingleton<BibleRepositoryFactory>(
    () => BibleRepositoryFactoryImpl({
      BibleRepositoryType.localDatabase: () => sl.get<BiblePaneRepository>(instanceName: BibleRepositoryType.localDatabase.name),
      BibleRepositoryType.sword: () => sl.get<BiblePaneRepository>(instanceName: BibleRepositoryType.sword.name),
      BibleRepositoryType.cloudAPI: () => sl.get<BiblePaneRepository>(instanceName: BibleRepositoryType.cloudAPI.name),
    }),
  );

  // init bible compiler
  sl.registerLazySingleton<ImporterRegistry>(() => ImporterRegistry([UsfxImporter(), OsisImporter()]),);
  sl.registerLazySingleton<SourceFetcherService>(() => SourceFetcherServiceImpl());

  // init book resolver
  sl.registerLazySingleton<BookResolver>(
    () => ChainedBookResolver([
      DriftBookResolver(sl()),
      ProgrammaticIdResolver(),
    ]),
  );

  // My Library
  sl.registerLazySingleton<MyLibraryCubit>(
    () => MyLibraryCubit(
      repo: sl.get<BibleCatalogRepository>(instanceName: BibleRepositoryType.localDatabase.name),
      notifier: sl(),
      installRepo: sl(),
    ),
    instanceName: BibleRepositoryType.localDatabase.name,
    onCreated: (c) => c.getBibles(),
  );
  sl.registerLazySingleton<MyLibraryCubit>(
    () => MyLibraryCubit(
      repo: sl.get<BibleCatalogRepository>(instanceName: BibleRepositoryType.sword.name),
      notifier: sl(),
      installRepo: sl(),
    ),
    instanceName: BibleRepositoryType.sword.name,
    onCreated: (c) => c.getBibles(),
  );


  // init customizer
  sl.registerLazySingleton<SettingsDatasource<CustomizerState>>(
    () => CustomizerDatasourceDesktopImpl(),
  );

  // Remote controller
  sl.registerLazySingleton<SettingsDatasource<RemoteControllerSettings>>(() => RemoteControllerSettingsDatasource());
  sl.registerLazySingleton<SettingsRepository<RemoteControllerSettings>>(() => RemoteControllerSettingsRepoImpl(localDatasource: sl()));
  sl.registerFactory(() => RemoteControllerSettingsCubit(repo: sl()));
  sl.registerLazySingleton(() => RemoteControllerWSServer());
  sl.registerLazySingleton(
    () => RemoteCommandRouter(
      handlers: {
        'search_bar': SearchBarHandler(bloc: sl<SearchBloc>()),
        'pane': PaneManagerHandler(
          multiPaneManagerCubit: sl<MultiPaneManagerCubit>(),
          myLibraryCubit: sl.get<MyLibraryCubit>(instanceName: BibleRepositoryType.localDatabase.name,),
        ),
      },
    ),
  );
  sl.registerLazySingleton<RemoteControllerRepo>(() => RemoteControllerRepoImpl(wsServer: sl(), router: sl()));
  sl.registerFactory(() => RemoteControllerCubit(repo: sl(), dispatcher: sl()));

  // Obs Live overlay
  sl.registerLazySingleton<SettingsDatasource<OverlaySettings>>(() => OverlaySettingsDatasourceImpl());
  sl.registerLazySingleton<SettingsRepository<OverlaySettings>>(() => OverlaySettingsRepoImpl(localDatasource: sl()));
  sl.registerFactory(() => ObsLiveOverlaySettingsCubit(repo: sl()));

  sl.registerLazySingleton<SelectedVerseBus>(() => SelectedVerseBus());
  sl.registerLazySingleton<OverlayFilesystem>(() => OverlayFilesystem());
  sl.registerLazySingleton<OverlayServerManager>(() => OverlayServerManager(fs: sl()));
  sl.registerLazySingleton<OverlayRepository>(() => OverlayRepositoryImpl(mgr: sl()));
  sl.registerFactory(() => ObsLiveOverlayCubit(repo: sl(), notifier: sl()));

  // Importer
  sl.registerLazySingleton<SettingsDatasource<BibleImporterSettings>>(() => BibleImporterSettingsDatasourceImpl());
  sl.registerLazySingleton<SettingsRepository<BibleImporterSettings>>(() => BibleImporterSettingsRepositoryImpl(datasource: sl()));
  sl.registerLazySingleton(() => BibleImporterSettingsCubit(settingsService: sl()));
  sl.registerFactory(() => BibleImporterCubit(repo: sl(), notifier: sl()));

  // Three tap nav
  sl.registerLazySingleton<ThreeTapNavigatorRepository>(
    () => ThreeTapNavigatorRepositoryImpl(
      contentDataSource: sl.get(
        instanceName: BibleRepositoryType.localDatabase.name,
      ),
      booksLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton(() => ThreeTapNavigatorCubit(repo: sl()));

  // Init Sword Bridge
  sl.registerSingleton<SwordBridge>(SwordBridge());

  sl.registerSingletonAsync<BibleImporterSettingsService>(() async {
    final service = BibleImporterSettingsServiceImpl(
      settingsRepo: sl<SettingsRepository<BibleImporterSettings>>(),
      bridge: sl<SwordBridge>(),
      installNotifier: sl(),
    );
    await service.initialize();
    return service;
  });
}
