import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  await di.init();

  WidgetsFlutterBinding.ensureInitialized();

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

// import 'package:flutter/material.dart';
// import 'dart:convert';

// import 'package:open_scripture/core/sword/sword_bridge.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final _bridge = SwordBridge();
//   String _status = 'Initialising...';
//   String _verse = '';
//   String _modules = '';

//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }

//   void _init() {
//     // Point at your local sword data directory
//     final ok = _bridge.init(r'C:\Users\jerom\sword');
//     if (!ok) {
//       setState(() => _status = 'ERROR: SWMgr init failed — check module path');
//       return;
//     }

//     // List installed modules
//     final modulesJson = _bridge.listModules();
//     final modules = jsonDecode(modulesJson) as List;

//     // Read John 3:16
//     final verse = _bridge.getVerse('KJV', 'gen 100');
//     // final verse = _bridge.testZlib();

//     setState(() {
//       _status = 'Engine ready — ${modules.length} module(s) found';
//       _modules =
//           modules.map((m) => '${m['name']}: ${m['description']}').join('\n');
//       _verse = verse;
//     });
//   }

//   @override
//   void dispose() {
//     _bridge.shutdown();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: const Color(0xFF1a1a2e),
//         body: Padding(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Status
//               Text(
//                 _status,
//                 style: const TextStyle(
//                   color: Color(0xFF00ff88),
//                   fontSize: 14,
//                   fontFamily: 'monospace',
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Verse
//               const Text(
//                 'John 3:16 (KJV)',
//                 style: TextStyle(
//                   color: Color(0xFF888888),
//                   fontSize: 12,
//                   fontFamily: 'monospace',
//                 ),
//               ),
//               const SizedBox(height: 8),
//               SelectableText(
//                 _verse.isEmpty ? '(no text returned)' : _verse,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   height: 1.6,
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Module list
//               const Text(
//                 'Installed modules:',
//                 style: TextStyle(
//                   color: Color(0xFF888888),
//                   fontSize: 12,
//                   fontFamily: 'monospace',
//                 ),
//               ),
//               const SizedBox(height: 8),
//               SelectableText(
//                 _modules.isEmpty ? '(none)' : _modules,
//                 style: const TextStyle(
//                   color: Color(0xFFaaaaaa),
//                   fontSize: 13,
//                   fontFamily: 'monospace',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
