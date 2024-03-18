import 'package:flutter/material.dart';
import 'package:the_smyrna_bible_v2/core/widgets/toolbar_app.dart';
import 'package:the_smyrna_bible_v2/features/translation_reader/presentation/widgets/bible_viewer.dart';
import 'injection_container.dart' as di;

void main() async {
  await di.init();

  runApp(const MyApp());
}

/// The Application doesn't have any route
/// because it's design to be single page
/// "Possible" pages instead will be displayed
/// as floating windows
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        fontFamily: 'General Sans',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ToolbarApp(
        options: [
          ToolbarOption(text: 'Bible'),
          ToolbarOption(text: 'Options'),
          ToolbarOption(text: 'Tools'),
          ToolbarOption(text: 'Help'),
        ],
        child: BibleViewer(),
      ),
    );
  }
}
