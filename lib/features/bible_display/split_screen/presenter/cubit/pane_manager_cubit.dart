import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../bible_pane/domain/repositories/bible_repository.dart';
import '../../../bible_pane/presentation/bloc/bible_pane_bloc.dart';
import '../split_pane_data.dart';

part 'pane_manager_state.dart';

const maxSplitsPaneX = 2;

class PaneManagerCubit extends Cubit<PaneManagerState> {
  PaneManagerCubit({
    required BibleRepository repo,
    int initialPaneId = 0,
  })  : _repo = repo,
        super(PaneManagerState(
          panes: [PaneDescriptor(id: initialPaneId)],
          activePaneId: initialPaneId,
        )) {
    _ensureBloc(initialPaneId);
  }

  final BibleRepository _repo;

  // Registry: NOT in state
  final Map<int, BiblePaneBloc> _blocs = {};

  BiblePaneBloc blocFor(int paneId) => _blocs[paneId]!;
  BiblePaneBloc activeBloc() => blocFor(state.activePaneId);

  void setActive(int paneId) {
    if (paneId == state.activePaneId) return;
    emit(PaneManagerState(panes: state.panes, activePaneId: paneId));
  }

  void splitNewPane() {
    // enforce max panes etc. here
    if (state.panes.length >= maxSplitsPaneX) return;

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
      () => BiblePaneBloc(paneId: paneId, repo: _repo),
    );
  }

  @override
  Future<void> close() async {
    for (final b in _blocs.values) {
      await b.close();
    }
    _blocs.clear();
    return super.close();
  }
}
