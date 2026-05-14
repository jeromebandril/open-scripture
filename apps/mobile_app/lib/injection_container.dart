import 'package:get_it/get_it.dart';

import 'services/client_ws.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => RemoteWsClient());
}
