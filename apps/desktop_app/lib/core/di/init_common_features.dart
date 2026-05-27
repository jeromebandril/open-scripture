import 'package:get_it/get_it.dart';
import 'package:open_scripture/app/state/fullscreen_cubit.dart';
import 'package:open_scripture/app/state/interface_visibility_cubit.dart';
import 'package:open_scripture/core/engines/settings/datasource/settings_datasource.dart';
import 'package:open_scripture/core/engines/settings/settings_repository.dart';
import 'package:open_scripture/core/infrastructure/book_resolver/book_resolver.dart';
import 'package:open_scripture/core/infrastructure/event_bus/install_notifier.dart';
import 'package:open_scripture/core/infrastructure/event_bus/navigation_bus.dart';
import 'package:open_scripture/core/infrastructure/event_bus/resolved_search_intent_bus.dart';
import 'package:open_scripture/core/infrastructure/window/app_window_manager.dart';
import 'package:open_scripture/features/bible_display/bible_pane/data/repositories/bible_pane_repository_impl.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
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
import 'package:open_scripture/features/shortcuts/data/repositories/shortcuts_repo_impl.dart';
import 'package:open_scripture/features/shortcuts/domain/repositories/shortcuts_repo.dart';
import 'package:open_scripture/features/shortcuts/presentation/models/app_command_dispatcher.dart';
import 'package:open_scripture/features/shortcuts/presentation/state/shortcuts_cubit.dart';
import 'package:open_scripture/features/text_scaler/presentation/state/text_scaler_cubit.dart';
import 'package:open_scripture/features/window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import 'package:open_scripture/shared/utils/bible_ref_parser/bible_ref_parser.dart';

import '../../features/customizer/data/datasources/customizer_datasource_web_impl.dart';

final _sl = GetIt.instance;

void initCommonFeatures() {
  _initInfrastructure();
  _initAppState();
  _initCustomizerFeature();
  _initWindowStackFeature();
  _initBSearchbarFeature();
  _initBibleSelectorFeature();
  _initReaderFeature();
  _initSplitScreenFeature();
  _initShortcutFeature();
}

// ---------------------------------------------------------------------------
// App-wide state & event buses
// ---------------------------------------------------------------------------
void _initAppState() {
  _sl.registerLazySingleton(() => NavigationBus());
  _sl.registerLazySingleton(() => ResolvedSearchIntentBus());
  _sl.registerLazySingleton(() => InstallNotifier());
  _sl.registerLazySingleton<AppWindowManager>(() => WindowManagerImpl());
  _sl.registerLazySingleton(() => FullscreenCubit(_sl<AppWindowManager>()));
  _sl.registerFactory(() => TextScalerCubit());
  _sl.registerFactory(() => FontLoaderCubit());
  _sl.registerLazySingleton(() => InterfaceVisibilityCubit());
}

// ---------------------------------------------------------------------------
// Infrastructure
// ---------------------------------------------------------------------------
void _initInfrastructure() {
  _sl.registerLazySingleton<BibleRefResolver>(
    () => BibleRefResolver(versification: Versification.allSupported),
  );
}

// ---------------------------------------------------------------------------
// Features
// ---------------------------------------------------------------------------

void _initCustomizerFeature() {
  _sl.registerLazySingleton<SettingsDatasource<CustomizerState>>(
    () => CustomizerDatasourceImpl(),
  );
  _sl.registerLazySingleton<SettingsRepository<CustomizerState>>(
    () => CustomizerRepoImpl(localDatasource: _sl()),
  );
  _sl.registerFactory(() => CustomizerCubit(repo: _sl()));
}

void _initWindowStackFeature() {
  _sl.registerFactory(() => WindowStackManagerBloc());
}

void _initBSearchbarFeature() {
  _sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      parser: _sl(),
      localDataSource: _sl(),
    ),
  );
  _sl.registerLazySingleton(() => SearchIntentResolver());
  _sl.registerLazySingleton<HistoryCubit>(() => HistoryCubit(navBus: _sl()));
  _sl.registerLazySingleton<SearchBloc>(
    () => SearchBloc(repo: _sl(), resolver: _sl(), searchIntentBus: _sl()),
  );
}

void _initBibleSelectorFeature() {
  _sl.registerFactory(() => BibleSelectorCubit());
}

void _initReaderFeature() {
  _sl.registerLazySingleton<BiblePaneRepository>(
    () => BiblePaneRepositoryImpl(
        localDatasource: _sl(), libraryDatasource: _sl()),
  );
  _sl.registerLazySingleton(() => BibleReferenceParser(resolver: _sl()));
}

void _initSplitScreenFeature() {
  _sl.registerLazySingleton<MultiPaneManagerCubit>(
    () => MultiPaneManagerCubit(repo: _sl(), searchIntentBus: _sl()),
  );
}

void _initShortcutFeature() {
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
