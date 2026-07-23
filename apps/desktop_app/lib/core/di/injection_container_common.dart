import 'package:get_it/get_it.dart';

import '../../app/state/fullscreen_cubit.dart';
import '../../app/state/interface_visibility_cubit.dart';
import '../../features/bible_display/bible_pane/data/repositories/bible_pane_repository_impl.dart';
import '../../features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import '../../features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import '../../features/bible_display/bible_selector/presentation/cubit/bible_selector_cubit.dart';
import '../../features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../features/bible_importer/presentation/state/bible_importer_cubit/bible_importer_cubit.dart';
import '../../features/bible_searchbar/history/presentation/state/history_cubit.dart';
import '../../features/bible_searchbar/search/data/repositories/search_repository_impl.dart';
import '../../features/bible_searchbar/search/domain/repositories/search_repository.dart';
import '../../features/bible_searchbar/search/domain/search_intent_resolver.dart';
import '../../features/bible_searchbar/search/presentation/state/search_bloc.dart';
import '../../features/customizer/presentation/state/customizer_cubit.dart';
import '../../features/font_loader/presentation/state/font_loader_cubit.dart';
import '../../features/my_library/presentation/state/my_library_cubit.dart';
import '../../features/my_library/settings/my_library_settings.dart';
import '../../features/my_library/settings/my_library_settings_cubit.dart';
import '../../features/shortcuts/data/repositories/shortcuts_repo_impl.dart';
import '../../features/shortcuts/domain/repositories/shortcuts_repo.dart';
import '../../features/shortcuts/presentation/models/app_command_dispatcher.dart';
import '../../features/shortcuts/presentation/state/shortcuts_cubit.dart';
import '../../features/text_scaler/presentation/state/text_scaler_cubit.dart';
import '../../features/three_tap_navigator/data/repository/three_tap_navigator_repository_impl.dart';
import '../../features/three_tap_navigator/domain/repository/three_tap_navigator_repository.dart';
import '../../features/three_tap_navigator/presentation/state/three_tap_navigator_cubit.dart';
import '../../features/window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import '../../shared/data/datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import '../../shared/data/datasources/bible_catalog_datasource/local_bible_catalog_datasource_impl.dart';
import '../../shared/data/datasources/bible_catalog_datasource/remote_bible_catalog_datasource_impl.dart';
import '../../shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import '../../shared/data/datasources/bible_content_datasource/drift_bible_content_datasource_impl.dart';
import '../../shared/data/datasources/bible_content_datasource/remote_bible_ccontent_datasource_impl.dart';
import '../../shared/data/datasources/bible_installation_datasource/drift_bible_installation_datasource_impl.dart';
import '../../shared/data/datasources/drift_book_local_datasource_impl.dart';
import '../../shared/data/repositories/bible_catalog_repository_impl.dart';
import '../../shared/data/repositories/bible_install_repository_impl.dart';
import '../../shared/data/repositories/drift_bible_book_repository_impl.dart';
import '../../shared/data/services/bible_installer_strategy/canonical_bible_installer_strategy.dart';
import '../../shared/data/services/book_resolvers/chained_book_resolver.dart';
import '../../shared/data/services/book_resolvers/drift_book_resolver.dart';
import '../../shared/data/services/book_resolvers/programmatic_book_resolver.dart';
import '../../shared/data/services/source_fetcher_service.dart';
import '../../shared/domain/entities/bible_id.dart';
import '../../shared/domain/repositories/bible_book_repository.dart';
import '../../shared/domain/repositories/bible_catalog_repository.dart';
import '../../shared/domain/repositories/bible_install_repository.dart';
import '../../shared/domain/repositories/bible_pane_repository_factory.dart';
import '../../shared/domain/services/book_resolver.dart';
import '../../shared/enums/bible_repository_type.dart';
import '../../shared/utils/bible_ref_parser/bible_ref_parser.dart';
import '../engines/bible_compiler/import/formats/osis_importer.dart';
import '../engines/bible_compiler/import/formats/usfx_importer.dart';
import '../engines/bible_compiler/import/importer_registry.dart';
import '../engines/settings/datasource/settings_datasource_desktop.dart';
import '../engines/settings/settings_repository.dart';
import '../infrastructure/database/daos/bible_content_dao.dart';
import '../infrastructure/database/daos/bible_installation_dao.dart';
import '../infrastructure/database/daos/installed_bibles_dao.dart';
import '../infrastructure/database/database.dart';
import '../infrastructure/event_bus/install_notifier.dart';
import '../infrastructure/event_bus/resolved_search_intent_bus.dart';
import '../infrastructure/event_bus/search_result_bus.dart';
import '../infrastructure/event_bus/selected_verse_bus.dart';
import '../infrastructure/window/app_window_manager.dart';

Future<void> init(GetIt sl) async {
  _registerDatabase(sl);
  _registerLocalDatabaseBible(sl);
  _registerMyLibrary(sl);
  _registerSearch(sl);
  _registerCloudBible(sl);
  _registerShortcuts(sl);
  _registerBibleImporter(sl);
  _registerThreeTapNavigator(sl);

  // bloc factory
  sl.registerFactoryParam<BiblePaneBloc, int, void>(
    (paneId, _) => BiblePaneBloc(
      libSettings: sl<SettingsRepository<MyLibrarySettings>>(),
      repositoryFactory: sl<BibleRepositoryFactory>(),
      paneId: paneId,
      navBus: sl.isRegistered<SearchResultBus>() ? sl<SearchResultBus>() : null,
      notifier:
          sl.isRegistered<SelectedVerseBus>() ? sl<SelectedVerseBus>() : null,
    ),
  );
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

  // init multipane
  sl.registerLazySingleton<MultiPaneManagerCubit>(() => MultiPaneManagerCubit(
      searchIntentBus: sl(), bookResolver: sl(), searchResultBus: sl()));

  // init Customizer
  sl.registerFactory(() => CustomizerCubit(repo: sl()));

  // init window stack manager
  sl.registerFactory(() => WindowStackManagerBloc());
  sl.registerFactoryParam<BibleSelectorCubit, List<BibleId>,
      BibleRepositoryType>((selectedIds,
          repoType) =>
      BibleSelectorCubit(selectedBiblesIds: selectedIds, repoType: repoType));

  // Configs / Settings
  sl.registerLazySingleton<SettingsRepository<MyLibrarySettings>>(
    () => SettingsRepositoryImpl<MyLibrarySettings>(
      SettingsDatasourceDesktop<MyLibrarySettings>(
        fileName: 'my_library_settings.json',
        fromJson: MyLibrarySettings.fromJson,
        toJson: (l) => l.toJson(),
        defaultValue: const MyLibrarySettings(),
      ),
    ),
    dispose: (repo) => repo.dispose(),
  );
  sl.registerSingleton(MyLibrarySettingsCubit(repo: sl()));
}

// ---------------------------------------------------------------------------
void _registerDatabase(GetIt sl) {
  sl.registerLazySingleton<AppDb>(() => AppDb());
  sl.registerLazySingleton<BibleContentDao>(() => BibleContentDao(sl()));
  sl.registerLazySingleton<InstalledBiblesDao>(() => InstalledBiblesDao(sl()));
  sl.registerLazySingleton<BibleInstallationDao>(
      () => BibleInstallationDao(sl()));
}

// ---------------------------------------------------------------------------
void _registerLocalDatabaseBible(GetIt sl) {
  const type = BibleRepositoryType.localDatabase;

  sl.registerLazySingleton<BibleCatalogDatasource>(
    () => LocalBibleCatalogDataSourceImpl(sl()),
    instanceName: type.name,
  );
  sl.registerLazySingleton<BibleContentDatasource>(
    () => DriftBibleContentDataSourceImpl(dao: sl()),
    instanceName: type.name,
  );
  sl.registerLazySingleton<BibleBookLocalDataSource>(
      () => DriftBibleBookLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<BibleInstallationDataSource>(
      () => DriftBibleInstallationDataSourceImpl(sl()));

  sl.registerLazySingleton<BibleBookRepository>(
      () => BibleBookRepositoryImpl(sl()));
  sl.registerLazySingleton<BibleCatalogRepository>(
    () => BibleCatalogRepositoryImpl(
        sl.get<BibleCatalogDatasource>(instanceName: type.name)),
    instanceName: type.name,
  );
  sl.registerLazySingleton<BiblePaneRepository>(
    () => BiblePaneRepositoryImpl(
      contentDatasource: sl.get(instanceName: type.name),
      catalogDatasource:
          sl.get<BibleCatalogDatasource>(instanceName: type.name),
    ),
    instanceName: type.name,
  );
}

// ---------------------------------------------------------------------------
void _registerSearch(GetIt sl) {
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
}

// ---------------------------------------------------------------------------
void _registerMyLibrary(GetIt sl) {
  sl.registerLazySingleton<MyLibraryCubit>(
    () => MyLibraryCubit(
      repoType: BibleRepositoryType.localDatabase,
      repo: sl.get<BibleCatalogRepository>(
          instanceName: BibleRepositoryType.localDatabase.name),
      notifier: sl(),
      installRepo: sl(),
    ),
    instanceName: BibleRepositoryType.localDatabase.name,
    onCreated: (c) => c.getBibles(),
  );
}

// ----------------------------------------------------------------------------
void _registerCloudBible(GetIt sl) {
  const type = BibleRepositoryType.cloudAPI;

  sl.registerLazySingleton<BibleCatalogDatasource>(
      () => RemoteBibleCatalogDatasourceImpl(),
      instanceName: type.name);
  sl.registerLazySingleton<BibleContentDatasource>(
      () => RemoteBibleContentDatasourceImpl(),
      instanceName: type.name);
  sl.registerLazySingleton<BibleCatalogRepository>(
    () => BibleCatalogRepositoryImpl(
        sl.get<BibleCatalogDatasource>(instanceName: type.name)),
    instanceName: type.name,
  );
  sl.registerLazySingleton<BiblePaneRepository>(
      () => BiblePaneRepositoryImpl(
          contentDatasource: sl.get(instanceName: type.name),
          catalogDatasource:
              sl.get<BibleCatalogDatasource>(instanceName: type.name)),
      instanceName: type.name);
  sl.registerLazySingleton<MyLibraryCubit>(
      () => MyLibraryCubit(
            repoType: type,
            repo: sl.get<BibleCatalogRepository>(instanceName: type.name),
            notifier: sl(),
          ),
      instanceName: type.name,
      onCreated: (c) => c.getBibles());
}

// ----------------------------------------------------------------------------
void _registerShortcuts(GetIt sl) {
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
}

// ----------------------------------------------------------------------------
void _registerBibleImporter(GetIt sl) {
  sl.registerFactory(() => BibleImporterCubit(repo: sl(), notifier: sl()));

  sl.registerLazySingleton<CanonicalInstallerStrategy>(
    () => CanonicalInstallerStrategy(
        fetcher: sl(), compiler: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<BibleInstallRepository>(
    () => BibleInstallRepositoryImpl({
      BibleRepositoryType.localDatabase: sl<CanonicalInstallerStrategy>(),
      // Sword's strategy is added dynamically the first time SwordService
      // boots. see `onCreated` above. Nothing forces that here.
    }),
  );

  sl.registerLazySingleton<ImporterRegistry>(
      () => ImporterRegistry([UsfxImporter(), OsisImporter()]));
  sl.registerLazySingleton<SourceFetcherService>(
      () => SourceFetcherServiceImpl());
  sl.registerLazySingleton<BookResolver>(
    () => ChainedBookResolver(
        [DriftBookResolver(sl()), ProgrammaticIdResolver()]),
  );
}

// ----------------------------------------------------------------------------
void _registerThreeTapNavigator(GetIt sl) {
  sl.registerLazySingleton<ThreeTapNavigatorRepository>(
    () => ThreeTapNavigatorRepositoryImpl(
      contentDataSource:
          sl.get(instanceName: BibleRepositoryType.localDatabase.name),
      booksLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton(() => ThreeTapNavigatorCubit(repo: sl()));
}

// ----------------------------------------------------------------------------
Future<void> warmUp(GetIt sl) async {
  // warm up settings (only those necessary on first frame)
  await sl<SettingsRepository<MyLibrarySettings>>().loadSettings();
}
