import 'package:flutter/material.dart';
import 'package:open_scripture_rc/services/device_identity_service.dart';

import 'app.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final identity = await DeviceIdentityService.get();
  await di.init(identity);

  runApp(const MyApp());
}
