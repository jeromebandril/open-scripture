import 'package:get_it/get_it.dart';
import 'injection_container_common.dart' as common;
import 'injection_container_platform.dart' as platform;

final sl = GetIt.instance;

Future<void> init() async {
  await common.init(sl);
  await platform.init(sl);
  await sl.allReady();
  platform.warmUpCore(sl);
}
