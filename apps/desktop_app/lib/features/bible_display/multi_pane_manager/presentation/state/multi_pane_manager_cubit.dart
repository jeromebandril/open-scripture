import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/core/infrastructure/event_bus/navigation_bus.dart';
import 'package:open_scripture/core/infrastructure/event_bus/resolved_search_intent_bus.dart';
import 'package:open_scripture/injection_container.dart';
import 'package:open_scripture/core/infrastructure/event_bus/selected_verse_bus.dart';

import '../../../../text_scaler/presentation/state/text_scaler_cubit.dart';
import '../../../bible_pane/domain/repositories/bible_pane_repository.dart';
import '../../../bible_pane/presentation/state/bible_pane_bloc.dart';
import '../../../bible_selector/presentation/state/bible_selector_bloc.dart';
import '../models/multi_pane_data.dart';

part 'multi_pane_manager_state.dart';

const _maxSplitsPaneX = 3;

class MultiPaneManagerCubit extends Cubit<PaneManagerState> {
  MultiPaneManagerCubit({
    required BiblePaneRepository repo,
    required ResolvedSearchIntentBus searchIntentBus,
    int initialPaneId = 0,
  })  : _resolvedSearchIntentBus = searchIntentBus,
        _repo = repo,
        super(PaneManagerState(
          panes: [PaneDescriptor(id: initialPaneId)],
          activePaneId: initialPaneId,
        )) {
    _ensureBloc(initialPaneId);

    _resolvedSearchIntentBus.stream.listen((intent) {
      final bloc = activePane().bloc;

      final event = switch (intent) {
        ResolvedReferenceIntent(:final ref, isVerseLevel: false) =>
          BiblePaneDisplayChapter(
            ref: ref,
            source: IntentSource.searchbar,
          ),
        ResolvedReferenceIntent(:final ref, isVerseLevel: true) =>
          BiblePaneJustChangeRef(
            ref: ref,
            source: IntentSource.searchbar,
            saveHistory: false,
          ),
        ResolvedStringSearchIntent(:final results) =>
          BiblePaneDisplayVerses(results),
      };

      bloc.add(event);
    });
  }

  final BiblePaneRepository _repo;
  final ResolvedSearchIntentBus _resolvedSearchIntentBus;
  final Map<int, PaneBlocComponents> _blocs = {};

  PaneBlocComponents paneBlocsFor(int paneId) => _blocs[paneId]!;
  PaneBlocComponents activePane() => paneBlocsFor(state.activePaneId);

  void setActive(int paneId) {
    if (paneId == state.activePaneId) return;
    emit(PaneManagerState(panes: state.panes, activePaneId: paneId));
  }

  void splitNewPane() {
    // enforce max panes etc. here
    if (state.panes.length >= _maxSplitsPaneX) return;

    final newId =
        (state.panes.map((p) => p.id).fold<int>(0, (m, e) => e > m ? e : m)) +
            1;
    _ensureBloc(newId);

    emit(PaneManagerState(
      panes: [...state.panes, PaneDescriptor(id: newId)],
      activePaneId: newId,
    ));
  }

  void closePane(int paneId) {
    if (state.panes.length == 1) return; // cannot close last pane

    _blocs.remove(paneId)?.close();

    final nextPanes = state.panes.where((p) => p.id != paneId).toList();
    final nextActive =
        state.activePaneId == paneId ? nextPanes.first.id : state.activePaneId;

    emit(PaneManagerState(panes: nextPanes, activePaneId: nextActive));
  }

  int _wrapIndex(int index, int length) {
    if (index < 0) return index + length;
    if (index >= length) return index - length;
    return index;
  }

  void swapPanesWithDelta(int paneId, int delta) {
    final panes = [...state.panes];
    final index = panes.indexWhere((p) => p.id == paneId);
    if (index == -1) return;

    final swapWithIndex = _wrapIndex(index + delta, panes.length);
    final tmp = panes[index];
    panes[index] = panes[swapWithIndex];
    panes[swapWithIndex] = tmp;

    emit(PaneManagerState(panes: panes, activePaneId: state.activePaneId));
  }

  void swapPanes(int aId, int bId) {
    final panes = [...state.panes];
    final ia = panes.indexWhere((p) => p.id == aId);
    final ib = panes.indexWhere((p) => p.id == bId);
    if (ia == -1 || ib == -1) return;

    final tmp = panes[ia];
    panes[ia] = panes[ib];
    panes[ib] = tmp;

    emit(PaneManagerState(panes: panes, activePaneId: state.activePaneId));
  }

  void _ensureBloc(int paneId) {
    _blocs.putIfAbsent(
      paneId,
      () => PaneBlocComponents(
        bloc: BiblePaneBloc(
          paneId: paneId,
          repo: _repo,
          navBus: sl<NavigationBus>(),
          notifier: sl<SelectedVerseBus>(),
        ),
        textScalerCubit: sl<TextScalerCubit>(),
        bibleSelectorCubit: sl<BibleSelectorBloc>(),
      ),
    );
  }

  @override
  Future<void> close() async {
    for (final b in _blocs.values) {
      await b.close();
    }
    _blocs.clear();
    _resolvedSearchIntentBus.dispose();
    return super.close();
  }
}
