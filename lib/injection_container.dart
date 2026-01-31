import 'package:get_it/get_it.dart';
import 'package:the_smyrna_bible_v2/core/presentation/cubit/display_mode_cubit.dart';
import 'package:the_smyrna_bible_v2/core/presentation/cubit/history_visibility_cubit.dart';
import 'package:the_smyrna_bible_v2/core/presentation/cubit/fullscreen_cubit.dart';
import 'package:the_smyrna_bible_v2/core/utils/bible_ref_parser/bible_ref_parser.dart';
import 'package:the_smyrna_bible_v2/core/database/database.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/data/repositories/b_searchbar_repository_impl.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/domain/repositories/b_searchbar_repository.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_selector/data/repositories/bible_selector_repository_impl.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_selector/presenter/bloc/bloc/bible_selector_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import 'package:the_smyrna_bible_v2/features/bible_importer/presentation/cubit/bible_importer_cubit.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/presentation/bloc/download_manager/bloc/download_manager_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/data/repositories/bible_repository_impl.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/domain/repositories/bible_repository.dart';
import 'package:the_smyrna_bible_v2/core/data/datasources/bible_ebibleorg_datasource.dart';
import 'package:the_smyrna_bible_v2/core/data/datasources/bible_sqllite_datasource.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/data/repositories/bible_manager_repository_impl.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/domain/repositories/bible_manager_repository.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/presentation/bloc/installed_bibles/installed_bibles_bloc.dart';
import 'package:the_smyrna_bible_v2/features/customizer/data/datasources/customizer_datasource.dart';
import 'package:the_smyrna_bible_v2/features/customizer/data/repo/customizer_repo_impl.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/repo/customizer_repo.dart';
import 'package:the_smyrna_bible_v2/features/customizer/presentation/cubit/customizer_cubit.dart';
import 'package:the_smyrna_bible_v2/features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
import 'core/domain/entities/book_names.dart';
import 'core/presentation/cubit/toolbar_cubit.dart';
import 'features/b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'features/bible_display/bible_pane/presentation/navigation_bus.dart';
import 'features/bible_display/bible_selector/domain/repositories/bible_selector_repository.dart';
import 'core/presentation/notifiers/install_notifier.dart';
import 'features/bible_installer_manager/presentation/bloc/remote_catalog/remote_catalog_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<BibleRefResolver>(
    () => BibleRefResolver(versification: Versification.protestant66),
  );

  initDatabase();

  initCustomizerFeature();

  initCore();

  initBibleManagerFeature();

  initBSearchbarFeature();

  initSplitScreenFeature();

  initReaderFeature();

  initBibleSelectorFeature();

  initBibleImporterFeature();

  // others
  sl.registerLazySingleton(() => NavigationBus());
  sl.registerFactory(() => ToolbarCubit());
  sl.registerFactory(() => FullscreenCubit());
  sl.registerFactory(() => DisplayModeCubit());
  sl.registerFactory(() => HistoryVisibilityCubit());
}

void initBibleImporterFeature() {
  sl.registerFactory(() => BibleImporterCubit());
}

void initCustomizerFeature() {
  sl.registerLazySingleton<CustomizerDatasource>(
    () => CustomizerDatasourceImpl(),
  );
  sl.registerLazySingleton<CustomizerRepo>(
    () => CustomizerRepoImpl(localDatasource: sl()),
  );
  sl.registerFactory(
    () => CustomizerCubit(repo: sl()),
  );
}

void initCore() {
  // Data sources
  sl.registerLazySingleton<BibleLocalDataSource>(
    () => BibleLocalDatasourceImpl(db: sl()),
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
