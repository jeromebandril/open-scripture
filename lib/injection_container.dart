import 'package:get_it/get_it.dart';
import 'package:the_smyrna_bible_v2/core/utils/bible_reference_parser.dart';
import 'package:the_smyrna_bible_v2/core/database/database.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/data/repositories/b_searchbar_repository_impl.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/domain/repositories/b_searchbar_repository.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/domain/usecases/split_horizontally.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/domain/usecases/split_vertically.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/presenter/bloc/split_screen_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/datasources/bible_local_datasource.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/bloc/settings_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/datasources/translations_datasource.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/repositories/reader_repository_impl.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/repositories/reader_repository.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/data/datasources/translation_manager_remote_datasource.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/data/datasources/translation_manager_local_datasource.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/data/repositories/translation_manager_repository_impl.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/repositories/translation_manager_repository.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/usecases/get_local_translations_info_list.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/usecases/get_translations_info_list.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/usecases/uninstall_translation.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/presentation/bloc/installed_translations_overview/installed_translations_bloc.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/presentation/bloc/translation_download_progress/translation_download_progress_bloc.dart';
import 'package:the_smyrna_bible_v2/features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
import 'features/b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'features/bible_display/translation_reader/presentation/bloc/reader_bloc.dart';
import 'features/translations_installer_manager/domain/usecases/download_translation.dart';
import 'features/translations_installer_manager/domain/usecases/install_translation.dart';
import 'features/translations_installer_manager/presentation/bloc/translations_overview/translations_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  initDatabase();

  initTranslationManagerFeature();

  initBSearchbarFeature();

  initSplitScreenFeature();

  initReaderFeature();
}

void initDatabase() {
  sl.registerLazySingleton<AppDb>(() => AppDb());
}

void initTranslationManagerFeature() {
  sl.registerFactory(
    () => AllTranslationsBloc(
      getTranslationsInfoList: sl(),
    ),
  );
  sl.registerFactory(
    () => InstalledTranslationsBloc(
      getLocalTranslationsInfoList: sl(),
      uninstallTranslation: sl(),
    ),
  );
  sl.registerFactory(
    () => TranslationDownloadProgressBloc(
      downloadTranslation: sl(),
      installTranslation: sl(),
    ),
  );
  sl.registerFactory(
    () => SettingsBloc(),
  );
  sl.registerFactory(
    () => WindowStackManagerBloc(),
  );

  // Use cases
  sl.registerLazySingleton(() => InstallUsfxTranslation(sl()));
  sl.registerLazySingleton(() => DownloadTranslation(sl()));
  sl.registerLazySingleton(() => GetTranslationsInfoList(sl()));
  sl.registerLazySingleton(() => GetLocalTranslationsInfoList(sl()));
  sl.registerLazySingleton(() => UninstallTranslation(sl()));

  // Repository
  sl.registerLazySingleton<TranslationManagerRepository>(
    () => TranslationManagerRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TranslationManagerLocalDataSource>(
    () => TranslationManagerLocalDataSourceImpl(db: sl()),
  );
  sl.registerLazySingleton<TranslationManagerRemoteDataSource>(
    () => TranslationManagerRemoteDataSourceImpl(),
  );
}

void initBSearchbarFeature() {
  // bloc
  sl.registerFactory(
    // !!!!
    () => BSearchbarBloc(repo: sl()),
  );

  sl.registerLazySingleton<BSearchbarRepository>(
    () => BSearchbarRepositoryImpl(parser: sl()),
  );
}

void initSplitScreenFeature() {
  sl.registerFactory(
    () => SplitScreenBloc(
      splitX: sl(),
      splitY: sl(),
    ),
  );
  sl.registerLazySingleton<SplitHorizontally>(() => SplitHorizontally());
  sl.registerLazySingleton<SplitVertically>(() => SplitVertically());
}

void initReaderFeature() {
  // bloc
  sl.registerFactory(
    () => ReaderBloc(repo: sl()),
  );

  // repositories
  sl.registerLazySingleton<ReaderRepository>(
    () => ReaderRepositoryImpl(localDatasource: sl()),
  );
  sl.registerLazySingleton(() => BibleReferenceParser());

  // datasource
  sl.registerLazySingleton<TranslationsDataSource>(
    () => TranslationsDataSourceImpl(db: sl()),
  );
  sl.registerLazySingleton<BibleLocalDatasource>(
    () => BibleLocalDatasourceImpl(db: sl()),
  );
}
