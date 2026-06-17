import 'package:get_it/get_it.dart';
import 'package:open_scripture/app/state/fullscreen_cubit.dart';
import 'package:open_scripture/app/state/interface_visibility_cubit.dart';
import 'package:open_scripture/core/engines/settings/settings_repository.dart';
import 'package:open_scripture/core/infrastructure/event_bus/install_notifier.dart';
import 'package:open_scripture/core/infrastructure/event_bus/resolved_search_intent_bus.dart';
import 'package:open_scripture/core/infrastructure/event_bus/search_result_bus.dart';
import 'package:open_scripture/core/infrastructure/event_bus/selected_verse_bus.dart';
import 'package:open_scripture/core/infrastructure/window/app_window_manager.dart';
import 'package:open_scripture/features/bible_display/bible_pane/data/repositories/bible_pane_repository_impl.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presentation/cubit/bible_selector_cubit.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/features/bible_searchbar/history/presentation/cubit/history_cubit.dart';
import 'package:open_scripture/features/bible_searchbar/search/data/repositories/search_repository_impl.dart';
import 'package:open_scripture/features/bible_searchbar/search/domain/repositories/search_repository.dart';
import 'package:open_scripture/features/bible_searchbar/search/domain/search_intent_resolver.dart';
import 'package:open_scripture/features/bible_searchbar/search/presentation/state/search_bloc.dart';
import 'package:open_scripture/features/customizer/data/repo/customizer_repo_impl.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/features/font_loader/presentation/state/font_loader_cubit.dart';
import 'package:open_scripture/features/my_library/presentation/cubit/my_library_cubit.dart';
import 'package:open_scripture/features/shortcuts/data/repositories/shortcuts_repo_impl.dart';
import 'package:open_scripture/features/shortcuts/domain/repositories/shortcuts_repo.dart';
import 'package:open_scripture/features/shortcuts/presentation/models/app_command_dispatcher.dart';
import 'package:open_scripture/features/shortcuts/presentation/state/shortcuts_cubit.dart';
import 'package:open_scripture/features/text_scaler/presentation/state/text_scaler_cubit.dart';
import 'package:open_scripture/features/window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/remote_bible_catalog_datasource_impl.dart';
import 'package:open_scripture/shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import 'package:open_scripture/shared/data/datasources/bible_content_datasource/remote_bible_ccontent_datasource_impl.dart';
import 'package:open_scripture/shared/data/repositories/bible_catalog_repository_impl.dart';
import 'package:open_scripture/shared/domain/entities/bible_id.dart';
import 'package:open_scripture/shared/domain/repositories/bible_catalog_repository.dart';
import 'package:open_scripture/shared/domain/repositories/bible_pane_repository_factory.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';
import 'package:open_scripture/shared/utils/bible_ref_parser/bible_ref_parser.dart';

Future<void> init(GetIt sl) async {
  //  Datasources
  sl.registerLazySingleton<BibleCatalogDatasource>(
      () => RemoteBibleCatalogDatasourceImpl(),
      instanceName: BibleRepositoryType.cloudAPI.name);
  sl.registerLazySingleton<BibleContentDatasource>(
      () => RemoteBibleContentDatasourceImpl(),
      instanceName: BibleRepositoryType.cloudAPI.name);

  // Repositories
  sl.registerLazySingleton<BibleCatalogRepository>(
    () => BibleCatalogRepositoryImpl(sl.get<BibleCatalogDatasource>(
        instanceName: BibleRepositoryType.cloudAPI.name)),
    instanceName: BibleRepositoryType.cloudAPI.name,
  );

  // Bible Pane
  // repositories
  sl.registerLazySingleton<BiblePaneRepository>(
      () => BiblePaneRepositoryImpl(
          contentDatasource:
              sl.get(instanceName: BibleRepositoryType.cloudAPI.name),
          catalogDatasource: sl.get<BibleCatalogDatasource>(
              instanceName: BibleRepositoryType.cloudAPI.name)),
      instanceName: BibleRepositoryType.cloudAPI.name);
  // bloc factory
  sl.registerFactoryParam<BiblePaneBloc, int, void>(
    (paneId, _) => BiblePaneBloc(
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

  // Shortcuts
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
            repo: sl.get<BibleCatalogRepository>(
                instanceName: BibleRepositoryType.cloudAPI.name),
            notifier: sl(),
          ),
      instanceName: BibleRepositoryType.cloudAPI.name,
      onCreated: (c) => c.getBibles());
}
