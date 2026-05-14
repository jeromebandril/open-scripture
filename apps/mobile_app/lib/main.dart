import 'package:flutter/material.dart';

import 'app.dart';
import 'injection_container.dart' as di;

void main() async {
  await di.init();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
