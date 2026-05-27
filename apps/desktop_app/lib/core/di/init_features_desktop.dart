import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:open_scripture/app/state/fullscreen_cubit.dart';
import 'package:open_scripture/app/state/interface_visibility_cubit.dart';
import 'package:open_scripture/core/engines/settings/datasource/settings_datasource.dart';
import 'package:open_scripture/core/infrastructure/bible_data/content/bible_content_datasource.dart';
import 'package:open_scripture/core/infrastructure/bible_data/content/bible_content_datasource_local_impl.dart';
import 'package:open_scripture/core/infrastructure/bible_data/install/bible_install_datasource.dart';
import 'package:open_scripture/features/bible_installer_manager/data/datasource/bible_download_datasource.dart';
import 'package:open_scripture/core/infrastructure/database/database.dart';
import 'package:open_scripture/core/infrastructure/event_bus/selected_verse_bus.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/formats/osis_importer.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/formats/usfx_importer.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/importer_registry.dart';
import 'package:open_scripture/core/engines/bible_compiler/source/packages/source_package_factory.dart';
import 'package:open_scripture/core/engines/remote_controller/remote_command_router.dart';
import 'package:open_scripture/core/engines/settings/settings_repository.dart';
import 'package:open_scripture/features/my_library/data/datasources/my_library_datasource.dart';
import 'package:open_scripture/features/my_library/data/datasources/my_library_datasource_local_impl.dart';
import 'package:open_scripture/features/my_library/data/repositories/my_library_repository_impl.dart';
import 'package:open_scripture/features/my_library/domain/repositories/my_library_repository.dart';
import 'package:open_scripture/features/my_library/presentation/cubit/my_library_cubit.dart';
import 'package:open_scripture/features/bible_searchbar/search/presentation/remote/search_handler.dart';
import 'package:open_scripture/features/bible_searchbar/search/presentation/state/search_bloc.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/remote/pane_manager_handler.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/features/bible_importer/data/repository/bible_importer_repo_impl.dart';
import 'package:open_scripture/features/bible_importer/domain/repository/bible_importer_repo.dart';
import 'package:open_scripture/features/bible_importer/presentation/state/bible_importer_cubit.dart';
import 'package:open_scripture/features/bible_installer_manager/data/repositories/bible_manager_repository_impl.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/repositories/bible_manager_repository.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/state/download_manager/bloc/download_manager_bloc.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/state/installer/installer_bloc.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/state/remote_catalog/remote_catalog_bloc.dart';
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
import 'package:open_scripture/features/three_tap_navigator/data/repository/three_tap_navigator_repository_impl.dart';
import 'package:open_scripture/features/three_tap_navigator/domain/repository/three_tap_navigator_repository.dart';
import 'package:open_scripture/features/three_tap_navigator/presentation/state/three_tap_navigator_cubit.dart';

final _sl = GetIt.instance;

void initPlatformSpecificFeatures() {
  _initDatabase();
  _initInfrastructure();
  _initInstaller();

  _initBibleInstallManagerFeature();
  _initMyLibraryFeature();
  _initBibleImporterFeature();
  _initThreeTapNavFeature();
  _initObsLiveOverlayFeature();
  _initRemoteControllerFeature();
}

// ---------------------------------------------------------------------------
// Infrastructure
// ---------------------------------------------------------------------------

void _initDatabase() {
  _sl.registerLazySingleton<AppDb>(() => AppDb());
}

void _initInstaller() {
  _sl.registerLazySingleton<UsfxImporter>(() => UsfxImporter());
  _sl.registerLazySingleton<OsisImporter>(() => OsisImporter());
  _sl.registerLazySingleton<ImporterRegistry>(
    () => ImporterRegistry([_sl<UsfxImporter>(), _sl<OsisImporter>()]),
  );
  _sl.registerLazySingleton<SourcePackageFactory>(
    () => const SourcePackageFactory(),
  );
}

void _initInfrastructure() {
  _sl.registerLazySingleton<BibleContentDatasource>(
    () => BibleContentDatasourceLocalImpl(
      db: _sl<AppDb>(),
      importerRegistry: _sl<ImporterRegistry>(),
      sourcePackageFactory: _sl<SourcePackageFactory>(),
    ),
  );
  _sl.registerLazySingleton<BibleDownloadDatasource>(
    () => BibleDownloadDatasourceImpl(),
  );
}

// ---------------------------------------------------------------------------
// Features
// ---------------------------------------------------------------------------

void _initBibleInstallManagerFeature() {
  if (kIsWeb) return;
  _sl.registerLazySingleton<BibleInstallDatasource>(
      () => BibleInstallDatasourceImpl());
  _sl.registerLazySingleton<BibleManagerRepository>(
    () => BibleManagerRepositoryImpl(
      installDatasource: _sl(),
      downloadDatasource: _sl(),
    ),
  );
  _sl.registerFactory(() => DownloadManagerBloc(repo: _sl(), notifier: _sl()));
  _sl.registerFactory(() => RemoteCatalogBloc(repository: _sl()));
  _sl.registerLazySingleton<InstallerBloc>(
      () => InstallerBloc(repository: _sl(), notifier: _sl()));
}

void _initMyLibraryFeature() {
  _sl.registerLazySingleton<MyLibraryDatasource>(
      () => MyLibraryDatasourceLocalImpl());
  // sl.registerLazySingleton<MyLibraryDatasource>(
  //     () => MyLibraryDatasourceDesktopImpl(),
  //     instanceName: 'remote');
  _sl.registerLazySingleton<MyLibraryRepository>(
      () => MyLibraryRepositoryImpl(datasource: _sl()));
  _sl.registerLazySingleton<MyLibraryCubit>(
      () => MyLibraryCubit(repo: _sl(), notifier: _sl()));
}

void _initBibleImporterFeature() {
  _sl.registerLazySingleton<BibleImporterRepo>(
    () => BibleImporterRepoImpl(localDataSource: _sl()),
  );
  _sl.registerFactory(() => BibleImporterCubit(repo: _sl(), notifier: _sl()));
}

void _initThreeTapNavFeature() {
  _sl.registerLazySingleton<ThreeTapNavigatorRepository>(
    () => ThreeTapNavigatorRepositoryImpl(localDataSource: _sl()),
  );
  _sl.registerLazySingleton(() => ThreeTapNavigatorCubit(repo: _sl()));
}

void _initObsLiveOverlayFeature() {
  if (kIsWeb) return;
  _sl.registerLazySingleton<SettingsDatasource<OverlaySettings>>(
    () => OverlaySettingsDatasourceImpl(),
  );
  _sl.registerLazySingleton<SettingsRepository<OverlaySettings>>(
    () => OverlaySettingsRepoImpl(localDatasource: _sl()),
  );
  _sl.registerFactory(() => ObsLiveOverlaySettingsCubit(repo: _sl()));

  _sl.registerLazySingleton<SelectedVerseBus>(
    () => SelectedVerseBus(),
  );
  _sl.registerLazySingleton<OverlayFilesystem>(() => OverlayFilesystem());
  _sl.registerLazySingleton<OverlayServerManager>(
    () => OverlayServerManager(fs: _sl()),
  );
  _sl.registerLazySingleton<OverlayRepository>(
    () => OverlayRepositoryImpl(mgr: _sl()),
  );
  _sl.registerFactory(() => ObsLiveOverlayCubit(repo: _sl(), notifier: _sl()));
}

void _initRemoteControllerFeature() {
  if (kIsWeb) return;
  _sl.registerLazySingleton<SettingsDatasource<RemoteControllerSettings>>(
    () => RemoteControllerSettingsDatasource(),
  );
  _sl.registerLazySingleton<SettingsRepository<RemoteControllerSettings>>(
    () => RemoteControllerSettingsRepoImpl(localDatasource: _sl()),
  );
  _sl.registerFactory(() => RemoteControllerSettingsCubit(repo: _sl()));

  _sl.registerLazySingleton(() => RemoteControllerWSServer());
  _sl.registerLazySingleton(
    () => RemoteCommandRouter(
      handlers: {
        'search_bar': SearchBarHandler(bloc: _sl<SearchBloc>()),
        'pane': PaneManagerHandler(
          multiPaneManagerCubit: _sl<MultiPaneManagerCubit>(),
          myLibraryCubit: _sl<MyLibraryCubit>(),
        ),
      },
    ),
  );
  _sl.registerLazySingleton<RemoteControllerRepo>(
    () => RemoteControllerRepoImpl(wsServer: _sl(), router: _sl()),
  );
  _sl.registerFactory(
    () => RemoteControllerCubit(repo: _sl(), dispatcher: _sl()),
  );
}

void initSplitScreenFeature() {
  _sl.registerLazySingleton<MultiPaneManagerCubit>(
    () => MultiPaneManagerCubit(repo: _sl(), searchIntentBus: _sl()),
  );
}

void initShortcutFeature() {
  _sl.registerLazySingleton(
    () => AppCommandDispatcher(
      paneManagerCubit: _sl<MultiPaneManagerCubit>(),
      searchbarBloc: _sl<SearchBloc>(),
      fullscreenCubit: _sl<FullscreenCubit>(),
      interfaceVisibilityCubit: _sl<InterfaceVisibilityCubit>(),
    ),
  );
  _sl.registerLazySingleton<ShortcutsRepo>(
    () => ShortcutsRepoImpl(dispatcher: _sl()),
  );
  _sl.registerLazySingleton(() => ShortcutsCubit(repo: _sl()));
}
