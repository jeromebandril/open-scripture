import 'package:get_it/get_it.dart';
import 'package:the_smyrna_bible_v2/core/models/translation_manager_model.dart';
import 'package:the_smyrna_bible_v2/core/utils/bible_reference_parser.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/domain/usecases/split_horizontally.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/domain/usecases/split_vertically.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/presenter/bloc/split_screen_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/get_translation.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/bloc/settings_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/datasources/translations_datasource.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/repositories/reader_repository_impl.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/repositories/reader_repository.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/read_chapter.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/open_usfx_translation.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/data/datasources/translation_manager_remote_datasource.dart';
import 'package:the_smyrna_bible_v2/core/datasources/translation_manager_local_datasource.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/data/repositories/translation_manager_repository_impl.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/repositories/translation_manager_repository.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/usecases/get_local_translations_info_list.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/usecases/get_translations_info_list.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/usecases/uninstall_translation.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/presentation/bloc/installed_translations_overview/installed_translations_bloc.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/presentation/bloc/translation_download_progress/translation_download_progress_bloc.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/presentation/bloc/translation_manager_bloc.dart';
import 'package:the_smyrna_bible_v2/features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
import 'features/bible_display/searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'features/bible_display/translation_reader/presentation/bloc/reader_bloc.dart';
import 'features/translations_installer_manager/domain/usecases/download_translation.dart';
import 'features/translations_installer_manager/domain/usecases/install_translation.dart';
import 'features/translations_installer_manager/presentation/bloc/translations_overview/translations_bloc.dart';

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

  // Features - Bible reader
  // bloc
  sl.registerFactory(
    () => ReaderBloc(
      // closeTranslation: sl(),
      readChapter: sl(),
      parser: sl(),
      openTranslation: sl(),
      getTranslation: sl(),
    ),
  );

  sl.registerLazySingleton(() => OpenUsfxTranslation(sl()));
  // sl.registerLazySingleton(() => CloseUsfxTranslation(sl()));

  sl.registerLazySingleton(() => ReadChapter(sl()));
  sl.registerLazySingleton(() => BibleReferenceParser());
  sl.registerLazySingleton(() => GetTranslation(sl()));

  sl.registerLazySingleton<ReaderRepository>(
    () => ReaderRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<TranslationsDataSource>(
    () => TranslationsDataSourceImpl(),
  );

  // Features - Bible reader
  // bloc
  sl.registerFactory(
    () => SplitScreenBloc(
      splitX: sl(),
      splitY: sl(),
    ),
  );
  sl.registerLazySingleton<SplitHorizontally>(() => SplitHorizontally());
  sl.registerLazySingleton<SplitVertically>(() => SplitVertically());

  // Features - BSearchbar
  sl.registerFactory(
    () => BSearchbarBloc(brParser: sl()),
  );
}
