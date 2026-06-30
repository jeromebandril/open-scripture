import 'package:get_it/get_it.dart';

import '../../features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import '../../features/customizer/data/datasources/customizer_datasource_web_impl.dart';
import '../../features/customizer/presentation/state/customizer_cubit.dart';
import '../../shared/data/repositories/bible_pane_repository_factory_impl.dart';
import '../../shared/data/services/book_resolvers/programmatic_book_resolver.dart';
import '../../shared/domain/repositories/bible_pane_repository_factory.dart';
import '../../shared/domain/services/book_resolver.dart';
import '../../shared/enums/bible_repository_type.dart';
import '../engines/settings/datasource/settings_datasource.dart';
import '../lifecycle/app_lifecycle.dart';
import '../lifecycle/app_lifecycle_web_impl.dart';

Future<void> init(GetIt sl) async {
  sl.registerLazySingleton<AppLifecycleService>(() => WebLifecycleService());

  // Book resolver
  sl.registerLazySingleton<BookResolver>(() => ProgrammaticIdResolver());

  // init customizer
  sl.registerLazySingleton<SettingsDatasource<CustomizerState>>(
    () => CustomizerDatasourceWebImpl(),
  );

  // Bible Pane
  // repository factory
  sl.registerLazySingleton<BibleRepositoryFactory>(
    () => BibleRepositoryFactoryImpl({
      BibleRepositoryType.cloudAPI: () => sl.get<BiblePaneRepository>(
          instanceName: BibleRepositoryType.cloudAPI.name),
    }),
  );
}
