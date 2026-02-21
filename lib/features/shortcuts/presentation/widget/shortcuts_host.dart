import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/presentation/cubit/fullscreen_cubit.dart';
import '../../../../shared/presentation/cubit/history_visibility_cubit.dart';
import '../../../../shared/presentation/cubit/toolbar_cubit.dart';
import '../../../b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import '../../../bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import '../models/app_command_dispatcher.dart';
import '../models/app_command_intent.dart';
import '../models/app_command_shortcuts.dart';

class ShortcutsHost extends StatefulWidget {
  const ShortcutsHost({
    super.key,
    required this.rootFocusNode,
    required this.child,
    required this.searchFocusNode,
    required this.historyFocusNode,
  });

  final FocusNode rootFocusNode;
  final Widget child;
  final FocusNode searchFocusNode;
  final FocusNode historyFocusNode;

  @override
  State<ShortcutsHost> createState() => _ShortcutsHostState();
}

class _ShortcutsHostState extends State<ShortcutsHost> {
  final FocusScopeNode _scopeNode =
      FocusScopeNode(debugLabel: 'app_shortcuts_scope');

  // @override
  // void initState() {
  //   super.initState();

  //   FocusManager.instance.addListener(() {
  //     final p = FocusManager.instance.primaryFocus;
  //     debugPrint('PRIMARY: ${p?.debugLabel}  '
  //         'root.hasFocus=${widget.rootFocusNode.hasFocus} '
  //         'root.hasPrimary=${widget.rootFocusNode.hasPrimaryFocus}');
  //   });
  // }

  @override
  void dispose() {
    _scopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dispatcher = AppCommandDispatcher(
      paneManagerCubit: context.read<PaneManagerCubit>(),
      searchbarBloc: context.read<BSearchbarBloc>(),
      historyVisibilityCubit: context.read<HistoryVisibilityCubit>(),
      toolbarCubit: context.read<ToolbarCubit>(),
      fullscreenCubit: context.read<FullscreenCubit>(),
      rootFocusNode: widget.rootFocusNode,
      searchFocusNode: widget.searchFocusNode,
      historyFocusNode: widget.historyFocusNode,
    );

    final actions = <Type, Action<Intent>>{
      AppCommandIntent: CallbackAction<AppCommandIntent>(
        onInvoke: (intent) {
          dispatcher.dispatch(intent.command);
          return null;
        },
      ),
    };

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // final primary = FocusManager.instance.primaryFocus;
        // If the user is currently editing text, do not steal focus.
        // final isEditingText = primary?.context?.widget is EditableText;
        // if (isEditingText) return;

        // If focus is already within this subtree, you can skip.
        // Minimal safe rule: ensure we always have a focus anchor.
        //if (!rootFocusNode.hasFocus) {
        widget.rootFocusNode.requestFocus();
        //}
      },
      child: Shortcuts(
        shortcuts: buildShortcutIntentMap(appCommandShortcuts),
        child: Actions(
          actions: actions,
          child: Focus(
            focusNode: widget.rootFocusNode,
            autofocus: true,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
