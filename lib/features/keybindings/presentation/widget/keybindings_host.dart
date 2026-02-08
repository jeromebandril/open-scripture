import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/shared/presentation/cubit/history_visibility_cubit.dart';
import 'package:open_scripture/shared/presentation/cubit/fullscreen_cubit.dart';
import 'package:open_scripture/shared/presentation/cubit/toolbar_cubit.dart';
import 'package:open_scripture/features/b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import '../../../bible_display/bible_pane/presentation/models/display_mode.dart';
import '../../../bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import '../../domain/app_command.dart';
import '../models/intents.dart';

// Convert to stateful widget and uncomment the following lines
// to debug the focus scope
//
// @override
// void initState() {
//   super.initState();
//   FocusManager.instance.addListener(_logFocus);
// }

// void _logFocus() {
//   final pf = FocusManager.instance.primaryFocus;
//   debugPrint('primaryFocus changed: $pf / ${pf?.debugLabel}');
// }

// @override
// void dispose() {
//   FocusManager.instance.removeListener(_logFocus);
//   super.dispose();
// }

Map<ShortcutActivator, Intent> buildShortcutIntentMap(
  Map<AppCommand, SingleActivator> source,
) {
  final result = <ShortcutActivator, Intent>{};

  for (final entry in source.entries) {
    result[entry.value] = AppCommandIntent(entry.key);
  }

  return result;
}

class ShortcutHost extends StatelessWidget {
  const ShortcutHost({
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
  Widget build(BuildContext context) {
    // Map intent -> action
    final actions = <Type, Action<Intent>>{
      AppCommandIntent: CallbackAction<AppCommandIntent>(
        onInvoke: (intent) {
          switch (intent.command) {
            case AppCommand.focusSearch:
              searchFocusNode.requestFocus();

              return;
            case AppCommand.toggleHistory:
              context.read<HistoryVisibilityCubit>().toggle();
              return;
            case AppCommand.toggleToolbar:
              context.read<ToolbarCubit>().toggleVisibility();
              return;
            case AppCommand.toggleFullscreen:
              context.read<FullscreenCubit>().toggle();
              historyFocusNode.requestFocus();
              return;
            case AppCommand.prevVerse:
              final activeBloc = context.read<PaneManagerCubit>().activeBloc();
              if (activeBloc.state.reference == null) return;
              final results = context.read<BSearchbarBloc>().state.results;
              //
              // Normal next verse
              //
              if (results.isEmpty) {
                final ref = activeBloc.state.reference!;
                if (ref.verseStart == 1) return;

                activeBloc.add(
                  BiblePaneJustChangeRef(
                      ref: ref.copyWith(
                    verseStart: (ref.verseStart ?? 1) - 1,
                    verseEnd: null,
                  )),
                );
                return;
              }
              //
              // Next verse on different verses
              //
              // TODO: fix problem with order
              final prev = results.indexOf(activeBloc.state.reference!) - 1;
              activeBloc.add(
                BiblePaneJustChangeRef(
                  ref: results[prev >= 0 ? prev : results.length - 1],
                ),
              );
            case AppCommand.nextVerse:
              final activeBloc = context.read<PaneManagerCubit>().activeBloc();
              if (activeBloc.state.reference == null) return;
              final results = context.read<BSearchbarBloc>().state.results;
              //
              // Normal next verse
              //
              if (results.isEmpty) {
                final ref = activeBloc.state.reference!;
                // TODO: add to state the number of verses
                // currently relying on last segment verse number (if it is ordered)
                if (ref.verseStart ==
                    activeBloc.state.segments.last.ref.verseStart) return;

                activeBloc.add(
                  BiblePaneJustChangeRef(
                      ref: ref.copyWith(
                    verseStart: (ref.verseStart ?? 0) + 1,
                    verseEnd: null,
                  )),
                );
                return;
              }
              //
              // Next verse on different verses
              //
              // TODO: fix problem with order
              final next = results.indexOf(activeBloc.state.reference!) + 1;
              activeBloc.add(
                BiblePaneJustChangeRef(
                  ref: results[next < results.length ? next : 0],
                ),
              );

              return;
            case AppCommand.nextPane:
              final panes = context.read<PaneManagerCubit>().state.panes;
              final activePaneId =
                  context.read<PaneManagerCubit>().state.activePaneId;
              final index = panes.indexWhere((p) => p.id == activePaneId);
              final nextIndex = index == panes.length - 1 ? 0 : index + 1;
              context.read<PaneManagerCubit>().setActive(nextIndex);

              return;
            case AppCommand.prevPane:
              final panes = context.read<PaneManagerCubit>().state.panes;
              final activePaneId =
                  context.read<PaneManagerCubit>().state.activePaneId;
              final index = panes.indexWhere((p) => p.id == activePaneId);
              final nextIndex = index == 0 ? panes.length - 1 : index - 1;
              context.read<PaneManagerCubit>().setActive(nextIndex);

              return;

            case AppCommand.changeBible:
              final active = context.read<PaneManagerCubit>().activeBloc();
              active.add(BiblePaneCloseBible());
              return;

            case AppCommand.switchDisplayMode:
              final ab = context.read<PaneManagerCubit>().activeBloc();
              final modes = DisplayMode.values;
              final i = modes.indexOf(ab.state.dMode);
              int next = 0;
              if (i < modes.length - 1) next = i + 1;
              ab.add(BiblePaneSetDisplayMode(modes[next]));
              return;
            case AppCommand.unfocusSearch:
              rootFocusNode.requestFocus();
              return;
            case AppCommand.displayChapterOfSelected:
              final activeBloc = context.read<PaneManagerCubit>().activeBloc();
              if (!activeBloc.state.isMixed) return;
              if (activeBloc.state.reference == null) return;
              activeBloc.add(BiblePaneDisplayChapter(
                ref: activeBloc.state.reference!,
              ));
              rootFocusNode.requestFocus();
              return;
            default:
              return;
          }
        },
      ),
    };

    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        // final primary = FocusManager.instance.primaryFocus;
        // If the user is currently editing text, do not steal focus.
        // final isEditingText = primary?.context?.widget is EditableText;
        // if (isEditingText) return;

        // If focus is already within this subtree, you can skip.
        // Minimal safe rule: ensure we always have a focus anchor.
        //if (!rootFocusNode.hasFocus) {
        rootFocusNode.requestFocus();
        //}
      },
      child: Actions(
        actions: actions,
        child: Shortcuts(
          shortcuts: buildShortcutIntentMap(appCommandShortcuts),
          child: Focus(
            focusNode: rootFocusNode,
            autofocus: true,
            child: child,
          ),
        ),
      ),
    );
  }
}
