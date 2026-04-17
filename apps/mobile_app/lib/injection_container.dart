import 'package:get_it/get_it.dart';

import 'service/client_ws.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => RemoteWsClient());

  await sl<RemoteWsClient>().connect("192.168.1.186", 50150);
}
