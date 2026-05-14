import 'package:get_it/get_it.dart';
import 'package:open_scripture_rc/services/device_identity_service.dart';

import 'services/client_ws.dart';

final sl = GetIt.instance;

Future<void> init(DeviceIdentity identity) async {
  sl.registerLazySingleton(() => RemoteWsClient(deviceIdentity: identity));
}
