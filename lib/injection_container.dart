import 'package:get_it/get_it.dart';
import 'package:the_smyrna_bible_v2/core/models/translation_manager_model.dart';
import 'package:the_smyrna_bible_v2/core/utils/bible_reference_parser.dart';
import 'package:the_smyrna_bible_v2/features/app_screen_manager/presentation/bloc/app_screen_manager_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/datasources/translations_datasource.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/models/translation_pool_model.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/models/translation_reader_model.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/repositories/reader_repository_impl.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/repositories/reader_repository.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/close_usfx_translation.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/display_chapter.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/read_usfx_translation.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/presentation/bloc/reader_bloc.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/data/datasources/translation_manager_remote_datasource.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/data/datasources/translation_manager_local_datasource.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/data/repositories/translation_manager_repository_impl.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/repositories/translation_manager_repository.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/usecases/get_local_translations_info_list.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/usecases/get_translations_info_list.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/usecases/uninstall_translation.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/presentation/bloc/installed_translations_overview/installed_translations_bloc.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/presentation/bloc/single_translation_download/single_translation_download_bloc.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/presentation/bloc/translation_manager_bloc.dart';
import 'features/translations_installer_manager/domain/usecases/download_translation.dart';
import 'features/translations_installer_manager/domain/usecases/install_translation.dart';
import 'features/translations_installer_manager/presentation/bloc/all_translations_overview/all_translations_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Translation manager
  // bloc
  sl.registerFactory(
    () => TranslationManagerBloc(
      allTranslationsBloc: sl(),
      installedTranslationsBloc: sl(),
      translationBloc: sl(),
    ),
  );
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
    () => SingleTranslationDownloadBloc(
      downloadTranslation: sl(),
    ),
  );
  sl.registerFactory(
    () => AppScreenManagerBloc(),
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
      manager: sl(),
    ),
  );

  // Models
  sl.registerLazySingleton(() => TranslationManagerModel());

  // Data sources
  sl.registerLazySingleton<TranslationManagerLocalDataSource>(
    () => TranslationManagerLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<TranslationManagerRemoteDataSource>(
    () => TranslationManagerRemoteDataSourceImpl(),
  );

  // Core

  // External

  // Features - Bible reader
  // bloc
  sl.registerFactory(
    () => ReaderBloc(
      readTranslation: sl(),
      closeTranslation: sl(),
      displayChapter: sl(),
      parser: sl(),
    ),
  );

  sl.registerLazySingleton(() => ReadUsfxTranslation(sl()));
  sl.registerLazySingleton(() => CloseUsfxTranslation(sl()));
  sl.registerLazySingleton(() => DisplayChapter(sl()));
  sl.registerLazySingleton(() => BibleReferenceParser());

  sl.registerLazySingleton<ReaderRepository>(
    () => ReaderRepositoryImpl(
      translationPool: sl(),
      reader: sl(),
      dataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => TranslationPoolModel());
  sl.registerLazySingleton(() => TranslationReaderModel());
  sl.registerLazySingleton<TranslationsDataSource>(
    () => TranslationsDataSourceImpl(),
  );
}
