import 'package:get_it/get_it.dart';
import 'injection_container_common.dart' as common;
import 'injection_container_platform.dart' as platform;

final sl = GetIt.instance;

// NOTE:
// Register/instantiate objects that must be ready *before* the UI builds
// (e.g. persisted settings, native resources) inside warmUp functions.
//
// Blocs/Cubits are never warmed up here. GetIt just registers them
// lazily. If a bloc/cubit needs to exist immediately at app startup rather
// than on first access, that's controlled in app.dart by using
// BlocProvider.value(...) instead of BlocProvider(create: ...).

Future<void> init() async {
  await common.init(sl);
  await platform.init(sl);
  await sl.allReady();
  await common.warmUp(sl);
  platform.warmUp(sl);
}
