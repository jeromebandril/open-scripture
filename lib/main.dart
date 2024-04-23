import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/app_screen_manager/presentation/widgets/app_screen_manager_wrapper.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_viewer/presenter/bloc/split_viewer_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_viewer/presenter/widgets/split_view_container.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/presentation/bloc/reader_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/presentation/widgets/bible_viewer.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/presentation/widgets/translation_manager_widget.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ReaderBloc>()),
        BlocProvider(create: (_) => di.sl<SplitViewerBloc>()),
      ],
      child: const Scaffold(
        body: AppScreenManagerWrapper(
          options: [
            ToolbarOption(text: 'Bible', opens: 'translation manager'),
            ToolbarOption(text: 'Options'),
            ToolbarOption(text: 'Tools'),
            ToolbarOption(text: 'Help'),
          ],
          windows: {'translation manager': TranslationManagerWidget()},
          child: BibleViewer(),
        ),
      ),
    );
  }
}
