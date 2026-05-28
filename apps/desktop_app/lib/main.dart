// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:window_manager/window_manager.dart';

// import 'app/app.dart';
// import 'core/di/injection_container.dart' as di;

// void main() async {
//   await di.init();

//   WidgetsFlutterBinding.ensureInitialized();

//   if (!kIsWeb) {
//     await windowManager.ensureInitialized();
//     WindowOptions windowOptions = WindowOptions(
//       size: Size(1000, 600),
//       minimumSize: Size(500, 300),
//       center: true,
//       backgroundColor: Colors.transparent,
//       skipTaskbar: false,
//       titleBarStyle: TitleBarStyle.hidden,
//     );
//     windowManager.waitUntilReadyToShow(windowOptions, () async {
//       await windowManager.show();
//       await windowManager.focus();
//     });
//   }

//   runApp(const MyApp());
// }

import 'package:flutter/material.dart';
import 'package:open_scripture/core/sword/sword_bridge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'not initialised';
  final _bridge = SwordBridge();

  @override
  void initState() {
    super.initState();
    // Point this at a real SWORD module directory once you have one installed.
    // For now it will return false (no modules) but proves the DLL loads.
    final ok = _bridge.init(r'C:\Users\Public\sword');
    setState(() {
      _status = ok ? 'engine ready' : 'init failed (no modules yet — expected)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text(_status)),
      ),
    );
  }
}
