import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'core/di/injection_container.dart' as di;
import 'core/infrastructure/database/database.dart';
import 'features/pericopes_mgr/data/services/pericope_importer_impl.dart';

void main() async {
  await di.init();

  WidgetsFlutterBinding.ensureInitialized();

  // Try installing the bundled pericopes.
  final db = di.sl<AppDb>();
  try {
    await PericopeImporter(db).installBundled(rootBundle.loadString);
  } catch (e, st) {
    debugPrint('Bundled pericopes install failed: $e\n$st');
  }

  // TODO: Maybe I should move this to a separate file, but for now, this is fine.
  // it's strange that compilation for web works fine, even though window_manager
  // is not supported on web.
  if (!kIsWeb) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(1000, 600),
      minimumSize: Size(500, 300),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}
