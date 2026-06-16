// import 'package:get_it/get_it.dart';
// import 'package:open_scripture/core/infrastructure/bible_data/content/bible_content_datasource_remote_impl.dart';
// import 'package:open_scripture/features/my_library/data/datasources/my_library_datasource.dart';
// import 'package:open_scripture/features/my_library/data/datasources/my_library_datasource_remote_impl.dart';
// import 'package:open_scripture/features/my_library/domain/repositories/my_library_repository.dart';

// import '../../features/my_library/data/repositories/my_library_repository_impl.dart';
// import '../../features/my_library/presentation/cubit/my_library_cubit.dart';
// import '../infrastructure/bible_data/content/bible_content_datasource.dart';

// final _sl = GetIt.instance;

// void initPlatformSpecificFeatures() {
//   _initInfrastructure();
//   _initMyLibraryFeature();
// }

// // ---------------------------------------------------------------------------
// // Infrastructure
// // ---------------------------------------------------------------------------

// void _initInfrastructure() {
//   _sl.registerLazySingleton<BibleContentDatasource>(
//     () => BibleContentDatasourceRemoteImpl(),
//   );
// }

// // ---------------------------------------------------------------------------
// // Features
// // ---------------------------------------------------------------------------

// void _initMyLibraryFeature() {
//   _sl.registerLazySingleton<MyLibraryDatasource>(
//       () => MyLibraryDatasourceRemoteImpl());
//   // sl.registerLazySingleton<MyLibraryDatasource>(
//   //     () => MyLibraryDatasourceDesktopImpl(),
//   //     instanceName: 'remote');
//   _sl.registerLazySingleton<MyLibraryRepository>(
//       () => MyLibraryRepositoryImpl(datasource: _sl()));
//   _sl.registerLazySingleton<MyLibraryCubit>(
//       () => MyLibraryCubit(repo: _sl(), notifier: _sl()));
// }
