import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../core/infrastructure/event_bus/resolved_search_intent_bus.dart';
import '../../../../../core/infrastructure/event_bus/search_result_bus.dart';
import '../../../../../shared/domain/services/book_resolver.dart';
import '../../../../text_scaler/presentation/state/text_scaler_cubit.dart';
import '../../../bible_pane/presentation/state/bible_pane_bloc.dart';
import '../models/multi_pane_data.dart';
import '../pane_animation_constants.dart';

part 'multi_pane_manager_state.dart';

const int _maxSplitsPaneX = 3;
const double _minSizeFactor = 0.2;

class MultiPaneManagerCubit extends Cubit<PaneManagerState> {
  final ResolvedSearchIntentBus _searchIntentBus;
  final SearchResultBus _searchResultBus;
  final BookResolver _bookResolver;
  final Map<int, PaneBlocComponents> _blocs = {};

  MultiPaneManagerCubit({
    required ResolvedSearchIntentBus searchIntentBus,
    required BookResolver bookResolver,
    required SearchResultBus searchResultBus,
    int initialPaneId = 0,
  })  : _searchIntentBus = searchIntentBus,
        _bookResolver = bookResolver,
        _searchResultBus = searchResultBus,
        super(PaneManagerState(
          panes: [PaneDescriptor(id: initialPaneId)],
          activePaneId: initialPaneId,
        )) {
    _ensureBloc(initialPaneId);

    _searchIntentBus.stream.listen(_routeSearchIntent);
  }

  PaneBlocComponents paneBlocsFor(int paneId) => _blocs[paneId]!;
  PaneBlocComponents activePane() => paneBlocsFor(state.activePaneId);

  void setActive(int paneId) {
    if (paneId == state.activePaneId) return;
    emit(PaneManagerState(panes: state.panes, activePaneId: paneId));
  }

  void splitNewPane() {
    if (state.panes.length >= _maxSplitsPaneX) return;

    final newId =
        (state.panes.map((p) => p.id).fold<int>(0, (m, e) => e > m ? e : m)) +
            1;

    // Init new pane with same text scale
    final currTextScale = activePane().textScalerCubit.state.textScaleFactor;
    _ensureBloc(newId, initTextScale: currTextScale);

    final newCount = state.panes.length + 1;
    final evenFactor = 1.0 / newCount;

    // redistribute all existing panes evenly, then append the new one.
    final newPanes = [
      ...state.panes.map((p) => p.copyWith(sizeFactor: evenFactor)),
      PaneDescriptor(id: newId, sizeFactor: evenFactor),
    ];

    emit(PaneManagerState(
      panes: newPanes,
      activePaneId: newId,
    ));
  }

  void closePane(int paneId) async {
    if (state.panes.length == 1) return; // cannot close last pane

    // (animation - phase 1): signal the widget to play the exit animation.
    emit(state.copyWith(removingPaneId: paneId));

    // Wait for the animation to finish before tearing down.
    await Future<void>.delayed(kPaneRemoveDuration);

    // (animation - phase 2): close blocs and drop the pane from state.
    await _blocs[paneId]?.close();
    _blocs.remove(paneId);

    // Redistribute size proportionally
    final panes = [...state.panes];
    final index = panes.indexWhere((p) => p.id == paneId);
    if (index == -1) return;
    //
    final closedSizeFactor = panes[index].sizeFactor;
    final remainingPanes = panes.where((p) => p.id != paneId).toList();
    final totalSizeFactor =
        remainingPanes.fold<double>(0, (sum, p) => sum + p.sizeFactor);
    //
    for (int i = 0; i < remainingPanes.length; i++) {
      final p = remainingPanes[i];
      final additionalSize = p.sizeFactor / totalSizeFactor * closedSizeFactor;
      remainingPanes[i] = p.copyWith(sizeFactor: p.sizeFactor + additionalSize);
    }

    // Get new active Id
    final int newActiveId;
    if (state.activePaneId == paneId) {
      final indexOfClosed = state.panes.indexWhere((p) => p.id == paneId);
      newActiveId =
          state.panes[_wrapIndex(indexOfClosed - 1, state.panes.length)].id;
    } else {
      newActiveId = state.activePaneId;
    }

    emit(PaneManagerState(
      panes: remainingPanes,
      activePaneId: newActiveId,
      removingPaneId: null,
    ));
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

  void _ensureBloc(int paneId, {double? initTextScale}) {
    final textScaler = sl<TextScalerCubit>();
    if (initTextScale != null) textScaler.initWith(initTextScale);

    _blocs.putIfAbsent(
      paneId,
      () => PaneBlocComponents(
        bloc: sl<BiblePaneBloc>(param1: paneId),
        textScalerCubit: textScaler,
        // bibleSelectorCubit: sl<BibleSelectorCubit>(),
      ),
    );
  }

  void resizeAdjacentPanes({
    required int leftPaneId,
    required int rightPaneId,
    required double deltaFactor,
  }) {
    final panes = [...state.panes];
    final leftIndex = panes.indexWhere((p) => p.id == leftPaneId);
    final rightIndex = panes.indexWhere((p) => p.id == rightPaneId);
    if (leftIndex == -1 || rightIndex == -1) return;

    final newLeftFactor = panes[leftIndex].sizeFactor + deltaFactor;
    final newRightFactor = panes[rightIndex].sizeFactor - deltaFactor;

    if (newLeftFactor < _minSizeFactor) return;
    if (newRightFactor < _minSizeFactor) return;

    panes[leftIndex] = panes[leftIndex].copyWith(sizeFactor: newLeftFactor);
    panes[rightIndex] = panes[rightIndex].copyWith(sizeFactor: newRightFactor);

    emit(state.copyWith(panes: panes));
  }

  @override
  Future<void> close() async {
    for (final b in _blocs.values) {
      await b.close();
    }
    _blocs.clear();
    _searchIntentBus.dispose();
    return super.close();
  }

  void _routeSearchIntent(ResolvedSearchIntent intent) async {
    final bloc = activePane().bloc;

    late final BiblePaneEvent event;
    switch (intent) {
      case ResolvedRefIntent(:final ref, isVerseLevel: false):
        event = BiblePaneDisplayChapter(
          ref: ref,
          source: IntentSource.searchbar,
        );
      case ResolvedRefIntent(:final ref, isVerseLevel: true):
        event = BiblePaneJustChangeRef(
          ref: ref,
          source: IntentSource.searchbar,
          saveHistory: false,
        );
      case ResolvedStringSearchIntent(:final results):
        event = BiblePaneDisplayVerses(results);
      case ResolvedPartialRefIntent():
        // resolve book
        final bibleLocalId =
            bloc.state.content.asMap.values.firstOrNull?.meta.localId;
        final book =
            await _bookResolver.resolve(intent.ref.bookToken, bibleLocalId);
        if (book == null) {
          _searchResultBus.emit(SearchResultError(
            source: IntentSource.searchbar,
            message: 'Could not resolve book from "${intent.ref.bookToken}"',
          ));
          return;
        }
        final ref = intent.ref.toFullRef(book);
        event = BiblePaneDisplayChapter(
          ref: ref,
          source: IntentSource.searchbar,
        );
    }

    bloc.add(event);
  }
}
