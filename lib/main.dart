import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/presenter/widgets/bible_searchbar.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/widgets/bible_pane_widget.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/presenter/widgets/split_view_container.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/presenter/widgets/split_view_controllers.dart';
import 'package:the_smyrna_bible_v2/features/keybindings/presentation/widget/keybindings_host.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/settings_window.dart';
import 'package:the_smyrna_bible_v2/features/toolbar/presentation/widgets/toolbar.dart';
import 'package:the_smyrna_bible_v2/features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
import 'package:the_smyrna_bible_v2/features/window_stack_manager/presentation/widgets/window_stack_manager_wrapper.dart';
import 'package:the_smyrna_bible_v2/injection_container.dart';
import 'features/b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'features/bible_display/bible_pane/domain/repositories/bible_repository.dart';
import 'features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import 'features/bible_installer_manager/presentation/bloc/installed_bibles/installed_bibles_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(const MyApp());
}

/// The Application doesn't have any route
/// because it's design to be single page app.
/// "Possible" pages will be instead displayed
/// as floating windows on top
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
              create: (_) =>
                  di.sl<PaneManagerCubit>()), // for one pane only for now
          BlocProvider(create: (_) => di.sl<WindowStackManagerBloc>()),
          BlocProvider(
              create: (_) =>
                  di.sl<InstalledBiblesBloc>()..add(InstalledBiblesLoad())),
          BlocProvider(create: (_) => di.sl<BSearchbarBloc>()),
        ],
        child: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final FocusNode _searchbarFocusNode;
  late final FocusNode _rootFocusNode;

  @override
  void initState() {
    super.initState();
    _searchbarFocusNode = FocusNode(debugLabel: 'searchbar');
    _rootFocusNode = FocusNode(debugLabel: 'root');
    // ..add(BiblePaneOpen(1)); // pick initial bibleId here
  }

  @override
  void dispose() {
    _searchbarFocusNode.dispose();
    _rootFocusNode.dispose();
    super.dispose();
  }

  // Return focus to root after search finishes
  void _returnFocusToRoot() {
    // This ensures there is always a focused node to receive shortcuts.
    _rootFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    // ShortcusHost must be at the very root after the MaterialApp
    return ShortcutHost(
      rootFocusNode: _rootFocusNode,
      searchFocusNode: _searchbarFocusNode,
      child: Scaffold(
        //
        // Manages the stacks of windosw that may occur when opening
        // popups or secondary pages in the form of a window (e.g. settings menu)
        //
        body: WindowStackManagerWrapper(
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
            child: Column(
              children: [
                Row(
                  children: [
                    BSearchbar(
                      focusNode: _searchbarFocusNode,
                      onSubmitted: () => _returnFocusToRoot(),
                      //onEditComplete: () => _returnFocusToRoot(),
                    ),
                    AddPaneXButton(),
                    RemovePaneButton(),
                    ActivePaneIndicator()
                  ],
                ),
                BlocListener<BSearchbarBloc, BSearchbarState>(
                  listenWhen: (prev, curr) =>
                      prev.referenceResult != curr.referenceResult,
                  listener: (context, state) {
                    final ref = state.referenceResult;
                    if (ref == null) return;

                    context.read<PaneManagerCubit>().activeBloc().add(
                          BiblePaneDisplayChapter(ref: ref, withSpans: true),
                        );
                  },
                  child: Expanded(child: MultipleBiblePanes()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
