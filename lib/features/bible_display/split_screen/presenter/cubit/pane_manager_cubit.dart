import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/navigation_bus.dart';
import 'package:open_scripture/injection_container.dart';
import 'package:open_scripture/shared/presentation/notifiers/selected_verse_content_notifier.dart';

import '../../../../text_scaler/cubit/text_scaler_cubit.dart';
import '../../../bible_pane/domain/repositories/bible_repository.dart';
import '../../../bible_pane/presentation/bloc/bible_pane_bloc.dart';
import '../../../bible_selector/presenter/bloc/bloc/bible_selector_bloc.dart';
import '../models/split_pane_data.dart';

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
  final Map<int, PaneBlocComponents> _blocs = {};

  PaneBlocComponents paneBlocsFor(int paneId) => _blocs[paneId]!;
  PaneBlocComponents activePane() => paneBlocsFor(state.activePaneId);

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
          notifier: sl<ContentOfSelectedVerseNotifier>(),
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
    return super.close();
  }
}
