import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/settings_window.dart';
import 'package:the_smyrna_bible_v2/features/toolbar/presentation/widgets/toolbar.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_viewer/presenter/bloc/split_viewer_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/presentation/bloc/reader_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/presentation/widgets/bible_view.dart';
import 'package:the_smyrna_bible_v2/features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
import 'package:the_smyrna_bible_v2/features/window_stack_manager/presentation/widgets/window_stack_manager_wrapper.dart';
import 'features/translations_installer_manager/presentation/bloc/installed_translations_overview/installed_translations_bloc.dart';
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
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => di.sl<ReaderBloc>()
              ..add(const ReaderLoadTranslation('eng-kjv')),
          ),
          BlocProvider(create: (_) => di.sl<SplitViewerBloc>()),
          BlocProvider(create: (_) => di.sl<WindowStackManagerBloc>()),
          BlocProvider(
            create: (_) => di.sl<InstalledTranslationsBloc>()
              ..add(InstalledTranslationsSubscriptionRequested()),
          ),
        ],
        child: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      // Manages the stacks of windosw that may occur when opening
      // popups or secondary pages in the form of a window (e.g. settings menu)
      //
      body: WindowStackManagerWrapper(
        //
        // Desktop look of a top toolbar
        //
        child: Toolbar(
          options: [
            ToolbarOption(
              'Bible',
              onTap: () {
                BlocProvider.of<WindowStackManagerBloc>(context).add(
                  WindowStackManagerOpen(
                    SettingsFactory.createSettingsWidget(
                      context,
                      'Bibles Manager',
                    ),
                  ),
                );
              },
            ),
            const ToolbarOption('Options'),
            const ToolbarOption('Tools'),
            ToolbarOption(
              'Help',
              onTap: () {
                BlocProvider.of<WindowStackManagerBloc>(context).add(
                  WindowStackManagerOpen(
                    SettingsFactory.createSettingsWidget(context, 'About'),
                  ),
                );
              },
            ),
          ],
          //
          // Main screen
          //
          child: BibleView(
            items: BlocProvider.of<InstalledTranslationsBloc>(context)
                .state
                .installedTranslations
                .map((e) => e.language)
                .toList(),
          ),
        ),
      ),
    );
  }
}
