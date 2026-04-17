import 'package:open_scripture/shared/presentation/cubit/toolbar_cubit.dart';

import '../../../../shared/domain/entities/bible_ref.dart';
import '../../../../shared/presentation/cubit/fullscreen_cubit.dart';
import '../../../../shared/presentation/cubit/history_visibility_cubit.dart';
import '../../../../shared/presentation/cubit/menubar_visibility_cubit.dart';
import '../../../b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import '../../../bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import '../../../bible_display/bible_pane/presentation/models/display_mode.dart';
import '../../../bible_display/bible_selector/presenter/bloc/bible_selector_bloc.dart';
import '../../../bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import '../../domain/models/app_command.dart';

typedef CommandHandler = void Function();

/// This executs only business logic.
/// Use the UiEffect dispatcher for Ui commands
class AppCommandDispatcher {
  AppCommandDispatcher({
    required this.paneManagerCubit,
    required this.searchbarBloc,
    required this.historyVisibilityCubit,
    required this.menubarCubit,
    required this.fullscreenCubit,
    // required this.rootFocusNode,
    // required this.searchFocusNode,
    // required this.historyFocusNode,
    required this.toolbarCubit,
  });

  final PaneManagerCubit paneManagerCubit;
  final BSearchbarBloc searchbarBloc;

  final HistoryVisibilityCubit historyVisibilityCubit;
  final MenubarCubit menubarCubit;
  final FullscreenCubit fullscreenCubit;
  final ToolbarCubit toolbarCubit;

  void dispatch(AppCommand command) {
    final handler = _handlers[command];
    if (handler == null) return;
    handler();
  }

  List<int> _prevBibleId = [];

  late final Map<AppCommand, CommandHandler> _handlers = {
    // AppCommand.focusSearch: () => searchFocusNode.requestFocus(),
    // AppCommand.unfocusSearch: () => rootFocusNode.requestFocus(),
    AppCommand.toggleHistory: () => historyVisibilityCubit.toggle(),
    AppCommand.toggleMenubar: () {
      menubarCubit.toggleVisibility();
      // rootFocusNode.requestFocus();
    },
    //AppCommand.toggleToolbar: () => toolbarCubit.toggleVisibility(),
    AppCommand.toggleFullscreen: () => fullscreenCubit.toggle(),
    AppCommand.nextPane: () => _cyclePane(1),
    AppCommand.prevPane: () => _cyclePane(-1),
    AppCommand.prevVerse: () => _moveVerse(-1),
    AppCommand.nextVerse: () => _moveVerse(1),
    AppCommand.addNextVerseToSelection: () => _extendSelection(1),
    AppCommand.removeVerseFromSelection: () => _extendSelection(-1),
    AppCommand.changeBible: () {
      final pane = paneManagerCubit.activePane();

      // undo/redo behavior: if the current pane has a bible, close it. otherwise, reopen the last closed bible.
      if (_prevBibleId.isNotEmpty &&
          pane.bloc.state.status == BiblePaneStatus.selectBibles) {
        pane.bloc.add(BiblePaneOpen(_prevBibleId));
        _prevBibleId = [];
        return;
      }

      _prevBibleId = pane.bloc.state.openedBiblesIds;
      if (_prevBibleId.isEmpty) return;
      pane.bloc.add(BiblePaneChooseBibles());
      pane.bibleSelectorCubit
          .add(BibleSelectorSetSelected(selectedBibleIds: _prevBibleId));
    },
    AppCommand.switchDisplayMode: () => _cycleDisplayMode(),
    AppCommand.displayChapterOfSelected: () => _displayChapterOfSelected(),
    AppCommand.addParallelPane: () => paneManagerCubit.splitNewPane(),
    AppCommand.closeCurrentPane: () =>
        paneManagerCubit.closePane(paneManagerCubit.state.activePaneId),
    AppCommand.zoomIn: () =>
        paneManagerCubit.activePane().textScalerCubit.zoomIn(),
    AppCommand.zoomOut: () =>
        paneManagerCubit.activePane().textScalerCubit.zoomOut(),
    AppCommand.movePaneToRight: () => paneManagerCubit.swapPanesWithDelta(
        paneManagerCubit.state.activePaneId, 1),
    AppCommand.movePaneToLeft: () => paneManagerCubit.swapPanesWithDelta(
        paneManagerCubit.state.activePaneId, -1),
  };

  T? _withActiveRef<T>(T Function(BiblePaneBloc bloc, BibleRef ref) fn) {
    final bloc = paneManagerCubit.activePane().bloc;
    final ref = bloc.state.reference;
    if (ref == null) return null;
    return fn(bloc, ref);
  }

  void _cyclePane(int delta) {
    final panes = paneManagerCubit.state.panes;
    if (panes.isEmpty) return;

    final activeId = paneManagerCubit.state.activePaneId;
    final index = panes.indexWhere((p) => p.id == activeId);
    if (index == -1) return;

    final wrapped = _wrapIndex(index + delta, panes.length);
    paneManagerCubit.setActive(panes[wrapped].id);
  }

  void _moveVerse(int delta) {
    _withActiveRef<void>((bloc, ref) {
      final results = searchbarBloc.state.results;

      // If there are search results, cycle through them.
      if (results.isNotEmpty) {
        final idx = results.indexOf(ref);
        if (idx == -1) return;

        final next = _wrapIndex(idx + delta, results.length);
        bloc.add(BiblePaneJustChangeRef(ref: results[next]));
        return;
      }

      // Otherwise, move inside the current chapter bounds.
      final a = bloc.state.unionRefs.toList();
      final iCurr = a.indexOf(ref.copyWith(verseEnd: null));
      if (iCurr != -1 && iCurr + delta < a.length && iCurr + delta >= 0) {
        final next = a[iCurr + delta];
        bloc.add(
          BiblePaneJustChangeRef(ref: next),
        );
      }
    });
  }

  void _extendSelection(int delta) {
    _withActiveRef<void>((bloc, ref) {
      final results = searchbarBloc.state.results;
      if (results.isNotEmpty) return; // keep your current behavior

      final last =
          bloc.state.verseCount ?? bloc.state.unionRefs.last.verseStart ?? 0;

      final start = ref.verseStart ?? 1;
      final end = ref.verseEnd ?? start;

      final nextEnd = end + delta;

      // match your original constraints
      if (delta > 0 && nextEnd > last) return;
      if (delta < 0 && (ref.verseEnd == null || ref.verseEnd == 1)) return;
      if (nextEnd < start) return;

      final newEnd = (delta < 0 && start == nextEnd) ? null : nextEnd;

      bloc.add(
        BiblePaneJustChangeRef(
          ref: ref.copyWith(verseEnd: newEnd),
        ),
      );
    });
  }

  void _cycleDisplayMode() {
    final bloc = paneManagerCubit.activePane().bloc;
    final modes = DisplayMode.values;
    final i = modes.indexOf(bloc.state.dMode);
    final next = (i < modes.length - 1) ? i + 1 : 0;
    bloc.add(BiblePaneSetDisplayMode(modes[next]));
  }

  void _displayChapterOfSelected() {
    final bloc = paneManagerCubit.activePane().bloc;
    if (!bloc.state.isMixed) return;

    final ref = bloc.state.reference;
    if (ref == null) return;

    bloc.add(BiblePaneDisplayChapter(ref: ref));
    // rootFocusNode.requestFocus();
  }

  int _wrapIndex(int index, int length) {
    if (length <= 0) return 0;
    final m = index % length;
    return m < 0 ? m + length : m;
  }
}
