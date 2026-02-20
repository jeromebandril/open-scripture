import 'package:get_it/get_it.dart';
import 'package:open_scripture/features/bible_importer/data/repository/bible_importer_repo_impl.dart';
import 'package:open_scripture/features/font_loader/presentation/cubit/font_loader_cubit.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/cubit/obs_overlay/obs_live_overlay_cubit.dart';
import 'package:open_scripture/features/text_scaler/cubit/text_scaler_cubit.dart';
import 'package:open_scripture/shared/data/datasources/settings_datasource.dart';
import 'package:open_scripture/shared/installer/bible/import/importer_registry.dart';
import 'package:open_scripture/shared/presentation/cubit/history_visibility_cubit.dart';
import 'package:open_scripture/shared/presentation/cubit/fullscreen_cubit.dart';
import 'package:open_scripture/shared/presentation/notifiers/selected_verse_content_notifier.dart';
import 'package:open_scripture/shared/utils/bible_ref_parser/bible_ref_parser.dart';
import 'package:open_scripture/shared/database/database.dart';
import 'package:open_scripture/features/b_searchbar/data/repositories/b_searchbar_repository_impl.dart';
import 'package:open_scripture/features/b_searchbar/domain/repositories/b_searchbar_repository.dart';
import 'package:open_scripture/features/bible_display/bible_selector/data/repositories/bible_selector_repository_impl.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presenter/bloc/bloc/bible_selector_bloc.dart';
import 'package:open_scripture/features/bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import 'package:open_scripture/features/bible_importer/presentation/cubit/bible_importer_cubit.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/bloc/download_manager/bloc/download_manager_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/data/repositories/bible_repository_impl.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/repositories/bible_repository.dart';
import 'package:open_scripture/shared/data/datasources/bible_ebibleorg_datasource.dart';
import 'package:open_scripture/shared/data/datasources/bible_sqllite_datasource.dart';
import 'package:open_scripture/features/bible_installer_manager/data/repositories/bible_manager_repository_impl.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/repositories/bible_manager_repository.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/bloc/installed_bibles/installed_bibles_bloc.dart';
import 'package:open_scripture/features/customizer/data/datasources/customizer_datasource.dart';
import 'package:open_scripture/features/customizer/data/repo/customizer_repo_impl.dart';
import 'package:open_scripture/features/customizer/domain/repo/customizer_repo.dart';
import 'package:open_scripture/features/customizer/presentation/cubit/customizer_cubit.dart';
import 'package:open_scripture/features/three_tap_navigator/data/repository/three_tap_navigator_repository_impl.dart';
import 'package:open_scripture/features/three_tap_navigator/domain/repository/three_tap_navigator_repository.dart';
import 'package:open_scripture/features/three_tap_navigator/presentation/cubit/three_tap_navigator_cubit.dart';
import 'package:open_scripture/features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
import 'features/bible_importer/domain/repository/bible_importer_repo.dart';
import 'features/obs_live_overlay/data/datasource/overlay_file_system.dart';
import 'features/obs_live_overlay/data/datasource/overlay_server_manager.dart';
import 'features/obs_live_overlay/data/repository/overlay_repository_impl.dart';
import 'features/obs_live_overlay/domain/repostiory/overlay_repository.dart';
import 'features/obs_live_overlay/presentation/cubit/cubit/obs_live_overlay_settings_cubit.dart';
import 'shared/domain/entities/book_names.dart';
import 'shared/installer/bible/import/formats/osis_importer.dart';
import 'shared/installer/bible/import/formats/usfx_importer.dart';
import 'shared/installer/bible/source/packages/source_package_factory.dart';
import 'shared/presentation/cubit/toolbar_cubit.dart';
import 'features/b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'features/bible_display/bible_pane/presentation/navigation_bus.dart';
import 'features/bible_display/bible_selector/domain/repositories/bible_selector_repository.dart';
import 'shared/presentation/notifiers/install_notifier.dart';
import 'features/bible_installer_manager/presentation/bloc/remote_catalog/remote_catalog_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<BibleRefResolver>(
    () => BibleRefResolver(versification: Versification.allSupported),
  );

  initDatabase();

  initCustomizerFeature();

  initInstaller();

  initCore();

  initBibleManagerFeature();

  initBSearchbarFeature();

  initSplitScreenFeature();

  initReaderFeature();

  initBibleSelectorFeature();

  initBibleImporterFeature();

  initThreeTapNavFeature();

  initObsLiveOverlayFeature();

  sl.registerFactory(() => TextScalerCubit());

  // others
  sl.registerLazySingleton(() => NavigationBus());
  sl.registerFactory(() => ToolbarCubit());
  sl.registerFactory(() => FullscreenCubit());
  sl.registerFactory(() => FontLoaderCubit());
  sl.registerFactory(() => HistoryVisibilityCubit());
}

void initThreeTapNavFeature() {
  sl.registerLazySingleton<ThreeTapNavigatorRepository>(
      () => ThreeTapNavigatorRepositoryImpl(localDataSource: sl()));
  sl.registerFactory(() => ThreeTapNavigatorCubit(repo: sl()));
}

void initBibleImporterFeature() {
  sl.registerLazySingleton<BibleImporterRepo>(
      () => BibleImporterRepoImpl(localDataSource: sl()));
  sl.registerFactory(() => BibleImporterCubit(repo: sl(), notifier: sl()));
}

void initCustomizerFeature() {
  sl.registerLazySingleton<SettingsDatasource<CustomizerState>>(
    () => CustomizerDatasourceImpl(),
  );
  sl.registerLazySingleton<CustomizerRepo>(
    () => CustomizerRepoImpl(localDatasource: sl()),
  );
  sl.registerFactory(
    () => CustomizerCubit(repo: sl()),
  );
}

void initInstaller() {
  sl.registerLazySingleton<UsfxImporter>(() => UsfxImporter());
  sl.registerLazySingleton<OsisImporter>(() => OsisImporter()); // later

  sl.registerLazySingleton<ImporterRegistry>(() => ImporterRegistry([
        sl<UsfxImporter>(),
        sl<OsisImporter>(),
      ]));

  sl.registerLazySingleton<SourcePackageFactory>(
    () => const SourcePackageFactory(),
  );
}

void initCore() {
  // Data sources
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
}

void initDatabase() {
  sl.registerLazySingleton<AppDb>(() => AppDb());
}

void initBibleManagerFeature() {
  sl.registerLazySingleton<InstallNotifier>(() => InstallNotifier());
  sl.registerFactory(
    () => DownloadManagerBloc(repo: sl(), notifier: sl()),
  );
  sl.registerFactory(
    () => RemoteCatalogBloc(repository: sl()),
  );
  sl.registerFactory(
    () => InstalledBiblesBloc(repository: sl(), notifier: sl()),
  );
  sl.registerFactory(
    () => WindowStackManagerBloc(),
  );

  // Repository
  sl.registerLazySingleton<BibleManagerRepository>(
    () => BibleManagerRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );
}

void initBSearchbarFeature() {
  // bloc
  sl.registerFactory(
    // !!!!
    () => BSearchbarBloc(repo: sl(), navBus: sl()),
  );

  sl.registerLazySingleton<BSearchbarRepository>(
    () => BSearchbarRepositoryImpl(
      parser: sl(),
      localDataSource: sl(),
    ),
  );
}

void initReaderFeature() {
  // // bloc
  // sl.registerFactory(
  //   () => BiblePaneBloc(repo: sl()),
  // );

  // repositories
  sl.registerLazySingleton<BibleRepository>(
    () => BibleRepositoryImpl(localDatasource: sl()),
  );
  sl.registerLazySingleton(() => BibleReferenceParser(resolver: sl()));
}

void initSplitScreenFeature() {
  sl.registerFactory(
    () => PaneManagerCubit(repo: sl()),
  );
}

void initBibleSelectorFeature() {
  sl.registerFactory(() => BibleSelectorBloc(repo: sl()));
  sl.registerLazySingleton<BibleSelectorRepository>(
    () => BibleSelectorRepositoryImpl(localDatasource: sl()),
  );
}

void initObsLiveOverlayFeature() {
  sl.registerLazySingleton<ContentOfSelectedVerseNotifier>(
      () => ContentOfSelectedVerseNotifier());
  sl.registerLazySingleton<OverlayFilesystem>(() => OverlayFilesystem());
  sl.registerLazySingleton<OverlayServerManager>(
      () => OverlayServerManager(fs: sl()));

  sl.registerLazySingleton<OverlayRepository>(
      () => OverlayRepositoryImpl(mgr: sl()));

  sl.registerFactory(() => ObsLiveOverlayCubit(repo: sl(), notifier: sl()));
  sl.registerFactory(() => ObsLiveOverlaySettingsCubit());
}
