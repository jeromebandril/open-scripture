import 'package:get_it/get_it.dart';

import '../../app/state/fullscreen_cubit.dart';
import '../../app/state/interface_visibility_cubit.dart';
import '../../features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import '../../features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../features/bible_searchbar/search/presentation/state/search_bloc.dart';
import '../../features/customizer/presentation/state/customizer_cubit.dart';
import '../../features/my_library/presentation/state/my_library_cubit.dart';
import '../../features/shortcuts/presentation/models/app_command_dispatcher.dart';
import '../../shared/data/repositories/bible_pane_repository_factory_impl.dart';
import '../../shared/domain/repositories/bible_pane_repository_factory.dart';
import '../../shared/enums/bible_repository_type.dart';
import '../settings/datasource/settings_datasource_web.dart';
import '../settings/settings_repository.dart';
import '../lifecycle/app_lifecycle.dart';
import '../lifecycle/app_lifecycle_web_impl.dart';

Future<void> init(GetIt sl) async {
  sl.registerLazySingleton<AppLifecycleService>(() => WebLifecycleService());

  sl.registerLazySingleton<SettingsRepository<CustomizerState>>(
    () => SettingsRepositoryImpl<CustomizerState>(
      SettingsDatasourceWeb<CustomizerState>(
        prefsKey: 'customizer_settings',
        fromJson: CustomizerState.fromJson,
        toJson: (s) => s.toJson(),
        defaultValue: const CustomizerState(),
      ),
    ),
    dispose: (repo) => repo.dispose(),
  );

  sl.registerLazySingleton<BibleRepositoryFactory>(
    () => BibleRepositoryFactoryImpl({
      BibleRepositoryType.cloudAPI: () async => sl.get<BiblePaneRepository>(
          instanceName: BibleRepositoryType.cloudAPI.name),
      BibleRepositoryType.localDatabase: () async =>
          sl.get<BiblePaneRepository>(
              instanceName: BibleRepositoryType.localDatabase.name),
    }),
  );

  sl.registerLazySingleton(
    () => AppCommandDispatcher(
      paneManagerCubit: () => sl<MultiPaneManagerCubit>(),
      searchbarBloc: () => sl<SearchBloc>(),
      fullscreenCubit: () => sl<FullscreenCubit>(),
      interfaceVisibilityCubit: () => sl<InterfaceVisibilityCubit>(),
    ),
  );
}

void warmUp(GetIt sl) {
  sl<AppLifecycleService>();
  sl<MyLibraryCubit>(instanceName: BibleRepositoryType.cloudAPI.name);
}
