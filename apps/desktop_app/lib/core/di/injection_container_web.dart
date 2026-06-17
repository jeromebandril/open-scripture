import 'package:get_it/get_it.dart';
import 'package:open_scripture/core/engines/settings/datasource/settings_datasource.dart';
import 'package:open_scripture/core/lifecycle/app_lifecycle.dart';
import 'package:open_scripture/core/lifecycle/app_lifecycle_web_impl.dart';
import 'package:open_scripture/features/customizer/data/datasources/customizer_datasource_web_impl.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/shared/data/services/book_resolvers/programmatic_book_resolver.dart';
import 'package:open_scripture/shared/domain/services/book_resolver.dart';

Future<void> init(GetIt sl) async {
  sl.registerLazySingleton<AppLifecycleService>(
    () => NoOpAppLifecycleService(),
  );

  // Book resolver
  sl.registerLazySingleton<BookResolver>(() => ProgrammaticIdResolver());

  // init customizer
  sl.registerLazySingleton<SettingsDatasource<CustomizerState>>(
    () => CustomizerDatasourceWebImpl(),
  );
}
