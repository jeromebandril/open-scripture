// @dart=3.12
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../app/state/fullscreen_cubit.dart';
import '../../app/state/interface_visibility_cubit.dart';
import '../../features/bible_display/bible_pane/data/repositories/bible_pane_repository_impl.dart';
import '../../features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import '../../features/bible_display/multi_pane_manager/presentation/remote/pane_manager_handler.dart';
import '../../features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../features/bible_searchbar/search/presentation/remote/search_handler.dart';
import '../../features/bible_searchbar/search/presentation/state/search_bloc.dart';
import '../../features/my_library/presentation/state/my_library_cubit.dart';
import '../../features/obs_live_overlay/data/datasource/overlay_control_server.dart';
import '../../features/obs_live_overlay/data/datasource/overlay_file_system.dart';
import '../../features/obs_live_overlay/data/repository/overlay_repository_impl.dart';
import '../../features/obs_live_overlay/data/service/verse_html_formatter_impl.dart';
import '../../features/obs_live_overlay/domain/repostiory/overlay_repository.dart';
import '../../features/obs_live_overlay/domain/service/verse_html_formatter.dart';
import '../../features/obs_live_overlay/presentation/state/obs_live_overlay_cubit.dart';
import '../../features/obs_live_overlay/settings/overlay_settings.dart';
import '../../features/remote_controller/data/datasource/remote_controller_ws.dart';
import '../../features/remote_controller/data/repositories/remote_controller_repo_impl.dart';
import '../../features/remote_controller/domain/repositories/remote_controller_repo.dart';
import '../../features/remote_controller/presentation/state/remote_controller_cubit.dart';
import '../../features/remote_controller/settings/remote_controller_settings.dart';
import '../../features/shortcuts/presentation/models/app_command_dispatcher.dart';
import '../../features/sword/settings/sword_engine_settings.dart';
import '../../features/sword/settings/sword_engine_settings_cubit.dart';
import '../../shared/data/datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import '../../shared/data/datasources/bible_catalog_datasource/sword_bible_catalog_datasource_impl.dart';
import '../../shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import '../../shared/data/datasources/bible_content_datasource/sword_bible_content_datasource_impl.dart';
import '../../shared/data/datasources/bible_installation_datasource/sword_bible_installation_datasource_impl.dart';
import '../../shared/data/repositories/bible_catalog_repository_impl.dart';
import '../../shared/data/repositories/bible_pane_repository_factory_impl.dart';
import '../../shared/data/services/bible_installer_strategy/sword_bible_installer_strategy.dart';
import '../../shared/data/services/sword_service.dart';
import '../../shared/domain/repositories/bible_catalog_repository.dart';
import '../../shared/domain/repositories/bible_install_repository.dart';
import '../../shared/domain/repositories/bible_pane_repository_factory.dart';
import '../../shared/enums/bible_repository_type.dart';
import '../engines/remote_controller/remote_command_router.dart';
import '../infrastructure/event_bus/selected_verse_bus.dart';
import '../lifecycle/app_lifecycle.dart';
import '../lifecycle/app_lifecycle_desktop_impl.dart';
import '../settings/datasource/settings_datasource_desktop.dart';
import '../settings/settings_cubit.dart';
import '../settings/settings_repository.dart';

// dart format off

Future<void> init(GetIt sl) async {
  _registerSwordBible(sl);
  _registerBibleSupport(sl); // importer, resolver, install repo, factory
  _registerRemoteController(sl);
  _registerObsOverlay(sl);
  _registerShortcuts(sl);
  _registerLifecycle(sl);
}

// ---------------------------------------------------------------------------
// OPTIONAL. Everything here is `registerLazySingletonAsync` because Sword
// genuinely needs to await settings/files. Nothing in this function is ever
// invoked during app start-up. the first real trigger is a widget asking
// for `instanceName: BibleRepositoryType.sword.name`.
// ---------------------------------------------------------------------------
void _registerSwordBible(GetIt sl) {
  const type = BibleRepositoryType.sword;

  sl.registerLazySingletonAsync<BibleCatalogDatasource>(
    () async => SwordBibleCatalogDatasourceImpl(swordService: await sl.getAsync<SwordService>()),
    instanceName: type.name,
  );
  sl.registerLazySingletonAsync<BibleContentDatasource>(
    () async => SwordBibleContentDatasourceImpl(swordService: await sl.getAsync<SwordService>()),
    instanceName: type.name,
  );
  sl.registerLazySingletonAsync<SwordInstallationDatasource>(
    () async => SwordBibleInstallationDatasourceImpl(swordService: await sl.getAsync<SwordService>()),
  );

  sl.registerLazySingletonAsync<BibleCatalogRepository>(
    () async => BibleCatalogRepositoryImpl(await sl.getAsync<BibleCatalogDatasource>(instanceName: type.name)),
    instanceName: type.name,
  );
  sl.registerLazySingletonAsync<BiblePaneRepository>(
    () async => BiblePaneRepositoryImpl(
      contentDatasource: await sl.getAsync<BibleContentDatasource>(instanceName: type.name),
      catalogDatasource: await sl.getAsync<BibleCatalogDatasource>(instanceName: type.name),
    ),
    instanceName: type.name,
  );

  sl.registerLazySingletonAsync<SettingsRepository<SwordEngineSettings>>(
    () async {
      final supportDir = await getApplicationSupportDirectory();
      final defaultPath = p.join(supportDir.path, 'sword');
      return SettingsRepositoryImpl<SwordEngineSettings>(
        SettingsDatasourceDesktop<SwordEngineSettings>(
          fileName: 'sword_engine_settings.json',
          fromJson: SwordEngineSettings.fromJson,
          toJson: (s) => s.toJson(),
          defaultValue: SwordEngineSettings(modulesPath: defaultPath),
        ),
      );
    },
    dispose: (repo) => repo.dispose(),
  );

  sl.registerLazySingletonAsync<SwordEngineSettingsCubit>(() async => SwordEngineSettingsCubit(
        repo: await sl.getAsync<SettingsRepository<SwordEngineSettings>>(),
        swordService: await sl.getAsync<SwordService>(),
      ));

  sl.registerLazySingletonAsync<SwordInstallerStrategy>(() async { 
    final strategy = SwordInstallerStrategy(
      fetcher: sl(),
      localDatasource: await sl.getAsync<SwordInstallationDatasource>(),
      swordSettingsRepo: await sl.getAsync<SettingsRepository<SwordEngineSettings>>(),
    ); 
    // when instanciated, register the strategy with the install repo so that it can be used by the factory
    sl.get<BibleInstallRepository>().registerStrategy(BibleRepositoryType.sword, strategy);
    return strategy;
  });

  // The one expensive resource: opens the native Sword bridge. `dispose`
  // only fires if this was actually created. see `_registerLifecycle`.
  sl.registerLazySingletonAsync<SwordService>(
    () async => SwordService(
      settingsRepo: await sl.getAsync<SettingsRepository<SwordEngineSettings>>(),
      installNotifier: sl(),
    ),
    dispose: (service) => service.shutdown(),
    onCreated: (service) => sl.getAsync<SwordInstallerStrategy>(),
  );

  sl.registerLazySingletonAsync<MyLibraryCubit>(
    () async => MyLibraryCubit(
      repoType: type,
      repo: await sl.getAsync<BibleCatalogRepository>(instanceName: type.name),
      notifier: sl(),
      installRepo: sl(), 
    ),
    instanceName: type.name,
    onCreated: (c) => c.getBibles(),
  );
}

// ---------------------------------------------------------------------------
void _registerBibleSupport(GetIt sl) {
  // Every repository type funnels through here. localDatabase & cloudAPI
  // resolve their Future immediately; sword genuinely awaits engine start-up.
  // Callers never need to know or care which case they're in.
  sl.registerLazySingleton<BibleRepositoryFactory>(
    () => BibleRepositoryFactoryImpl({
      BibleRepositoryType.localDatabase: () async =>
          sl.get<BiblePaneRepository>(instanceName: BibleRepositoryType.localDatabase.name),
      BibleRepositoryType.sword: () =>
          sl.getAsync<BiblePaneRepository>(instanceName: BibleRepositoryType.sword.name),
      BibleRepositoryType.cloudAPI: () async =>
          sl.get<BiblePaneRepository>(instanceName: BibleRepositoryType.cloudAPI.name),
    }),
  );
}


void _registerRemoteController(GetIt sl) {
  sl.registerLazySingleton<SettingsRepository<RemoteControllerSettings>>(
    () => SettingsRepositoryImpl<RemoteControllerSettings>(
      SettingsDatasourceDesktop<RemoteControllerSettings>(
        fileName: 'remote_controller_settings.json',
        fromJson: RemoteControllerSettings.fromJson,
        toJson: (s) => s.toJson(),
        defaultValue: const RemoteControllerSettings(),
      ),
    ),
    dispose: (repo) => repo.dispose(),
  );
  sl.registerFactory(() => SettingsCubit<RemoteControllerSettings>(sl()));
  sl.registerLazySingleton(() => RemoteControllerWSServer());
  sl.registerLazySingleton<RemoteCommandRouter>(
    () => RemoteCommandRouter(
      handlers: {
        'search_bar': SearchBarHandler(bloc: sl<SearchBloc>()),
        'pane': PaneManagerHandler(
          multiPaneManagerCubit: sl<MultiPaneManagerCubit>(),
          myLibraryCubit: sl.get<MyLibraryCubit>(instanceName: BibleRepositoryType.localDatabase.name),
        ),
      },
    ),
  );
  sl.registerLazySingleton<RemoteControllerRepo>(() => RemoteControllerRepoImpl(wsServer: sl(), router: sl()));
  sl.registerFactory(() => RemoteControllerCubit(repo: sl(), dispatcher: sl()));
}

void _registerObsOverlay(GetIt sl) {
  sl.registerLazySingleton<SettingsRepository<OverlaySettings>>(
    () => SettingsRepositoryImpl<OverlaySettings>(
      SettingsDatasourceDesktop<OverlaySettings>(
        fileName: 'overlay_settings.json',
        fromJson: OverlaySettings.fromJson,
        toJson: (s) => s.toJson(),
        defaultValue: const OverlaySettings(),
      ),
    ),
    dispose: (repo) => repo.dispose(),
  );
  sl.registerFactory(() => SettingsCubit<OverlaySettings>(sl()));

  sl.registerLazySingleton<VerseHtmlFormatter>(() => VerseHtmlFormatterImpl());

  sl.registerLazySingleton<SelectedVerseBus>(() => SelectedVerseBus());
  sl.registerLazySingleton<OverlayFilesystem>(() => OverlayFilesystem());
  sl.registerLazySingleton<OverlayControlServer>(() => OverlayControlServer(
    ensureAssetsExtracted: sl<OverlayFilesystem>().ensureExtracted, 
    readOverlayFile: sl<OverlayFilesystem>().readOverlayFile 
  ));
  sl.registerLazySingleton<OverlayRepository>(() => OverlayRepositoryImpl(server: sl<OverlayControlServer>(), settings: sl<SettingsRepository<OverlaySettings>>(), filesystem: sl()));
  sl.registerLazySingleton(() => ObsLiveOverlayCubit(repo: sl(), selectedVerseBus: sl(), htmlFormatter: sl(), settings: sl()));
}

void _registerLifecycle(GetIt sl) {
  sl.registerLazySingleton<AppLifecycleService>(
    () => DesktopAppLifecycleService(
      // Cheap no-op if Sword was never touched this session: does NOT
      // create SwordService just to dispose it, and only runs on close.
      onAppClose: () => sl.resetLazySingleton<SwordService>()
    ),
  );
}

void _registerShortcuts(GetIt sl) {
  sl.registerLazySingleton(
    () => AppCommandDispatcher(
      paneManagerCubit: () => sl<MultiPaneManagerCubit>(),
      searchbarBloc: () => sl<SearchBloc>(),
      fullscreenCubit: () => sl<FullscreenCubit>(),
      interfaceVisibilityCubit: () => sl<InterfaceVisibilityCubit>(),
      overlayCubit: () => sl<ObsLiveOverlayCubit>(),
    ),
  );
}

// Called once from main.dart right after init() completes. this is where
// "core" is actually decided, not in the registration style above.
void warmUp(GetIt sl) {
  sl<AppLifecycleService>();
  sl<MyLibraryCubit>(instanceName: BibleRepositoryType.localDatabase.name);
}

