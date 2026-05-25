import 'package:open_scripture/core/app_state/interface_visibility_cubit.dart';

import '../../../../shared/entities/bible_ref.dart';
import '../../../../core/app_state/fullscreen_cubit.dart';
import '../../../bible_searchbar/search/presentation/state/search_bloc.dart';
import '../../../bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import '../../../bible_display/bible_pane/domain/display_mode.dart';
import '../../../bible_display/bible_selector/presentation/state/bible_selector_bloc.dart';
import '../../../bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../domain/models/app_command.dart';

typedef CommandHandler = void Function();

/// This executs only business logic.
/// Use the UiEffect dispatcher for Ui commands
class AppCommandDispatcher {
  AppCommandDispatcher({
    required this.paneManagerCubit,
    required this.searchbarBloc,
    required this.fullscreenCubit,
    required this.interfaceVisibilityCubit,
  });

  final MultiPaneManagerCubit paneManagerCubit;
  final SearchBloc searchbarBloc;

  final FullscreenCubit fullscreenCubit;
  final InterfaceVisibilityCubit interfaceVisibilityCubit;

  void dispatch(AppCommand command) {
    final handler = _handlers[command];
    if (handler == null) return;
    handler();
  }

  List<int> _prevBibleId = [];

  late final Map<AppCommand, CommandHandler> _handlers = {
    // AppCommand.focusSearch: () => searchbarVisibilityCubit.set(true),
    AppCommand.closeWhatever: () {
      interfaceVisibilityCubit.hideAll();
    },
    AppCommand.toggleHistory: () => interfaceVisibilityCubit.toggleHistory(),
    AppCommand.toggleToolbar: () {
      interfaceVisibilityCubit.toggleToolbar();
    },
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
      final searchState = searchbarBloc.state;

      // If in string search mode, cycle through the results.
      if (searchState is SearchStringResult) {
        final results = searchState.results;
        final idx = results.indexOf(ref);
        if (idx == -1) return;
        final next = _wrapIndex(idx + delta, results.length);
        bloc.add(BiblePaneJustChangeRef(ref: results[next]));
        return;
      }

      // Otherwise, move inside the current chapter bounds.
      final refs = bloc.state.unionRefs.toList();
      final iCurr = refs.indexOf(ref.copyWith(verseEnd: null));
      if (iCurr != -1 && iCurr + delta < refs.length && iCurr + delta >= 0) {
        bloc.add(BiblePaneJustChangeRef(ref: refs[iCurr + delta]));
      }
    });
  }

  void _extendSelection(int delta) {
    _withActiveRef<void>((bloc, ref) {
      if (searchbarBloc.state is SearchStringResult) return;

      final last =
          bloc.state.verseCount ?? bloc.state.unionRefs.last.verseStart ?? 0;
      final start = ref.verseStart ?? 1;
      final end = ref.verseEnd ?? start;
      final nextEnd = end + delta;

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
