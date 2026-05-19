import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/core/infrastructure/event_bus/resolved_search_intent_bus.dart';
import 'package:open_scripture/features/bible_searchbar/domain/search_intent.dart';
import 'package:open_scripture/features/bible_searchbar/domain/search_intent_resolver.dart';
import 'package:open_scripture/features/bible_searchbar/presentation/models/history_data.dart';
import 'package:open_scripture/core/infrastructure/event_bus/navigation_bus.dart';
import 'package:open_scripture/shared/entities/bible_ref.dart';

import '../../domain/searchbar_repository.dart';

part 'b_searchbar_event.dart';
part 'b_searchbar_state.dart';

class BSearchbarBloc extends Bloc<BSearchbarEvent, BSearchbarState> {
  BSearchbarBloc({
    required BSearchbarRepository repo,
    required SearchIntentResolver resolver,
    required ResolvedSearchIntentBus searchIntentBus,
    NavigationBus? navBus,
  })  : _searchIntentBus = searchIntentBus,
        _repo = repo,
        _resolver = resolver,
        _navBus = navBus,
        super(const SearchIdle(history: [])) {
    on<BSearchbarParseIntent>(_onParseIntent);
    on<_SaveInHistory>(_onSaveInHistory);
    on<DeleteHistoryItem>(_onDeleteHistoryItem);
    on<BSearchbarUpdateRef>(_onUpdateRef);

    _sub = _navBus?.stream.listen((event) {
      if (event.source != IntentSource.searchbar) return;
      add(_SaveInHistory(event));
    });
  }

  final BSearchbarRepository _repo;
  final SearchIntentResolver _resolver;
  final NavigationBus? _navBus;
  final ResolvedSearchIntentBus _searchIntentBus;
  StreamSubscription<NavigationFeedback>? _sub;

  Future<void> _onParseIntent(
    BSearchbarParseIntent event,
    Emitter<BSearchbarState> emit,
  ) async {
    final intent = _resolver.resolve(event.query);

    switch (intent) {
      case ReferenceIntent():
        final result = await _repo.parseBibleRef(intent.rawQuery);
        result.fold(
          (f) => emit(SearchError(
            message: f.details,
            history: state.history,
            errorCount: state.errorCount + 1,
          )),
          (ref) {
            emit(SearchReferenceResult(ref: ref, history: state.history));
            _searchIntentBus
                .emit(ResolvedReferenceIntent(ref: ref, isVerseLevel: false));
          },
        );
        break;

      case VerseNumberIntent():
        // VerseNumberIntent refines an existing reference result.
        // If there is no prior reference in state, the intent is a no-op.
        final current = state;
        if (current is! SearchReferenceResult) return;
        final refinedRef = current.ref
            .copyWith(verseStart: intent.verseNumber, verseEnd: null);
        emit(SearchReferenceResult(ref: refinedRef, history: state.history));
        _searchIntentBus
            .emit(ResolvedReferenceIntent(ref: refinedRef, isVerseLevel: true));
        break;

      case StringSearchIntent():
      // final result = await _repo.searchByString(intent.query);
      // result.fold(
      //   (f) => emit(SearchError(
      //     message: f.message,
      //     history: state.history,
      //   )),
      //   (verses) => emit(SearchStringResult(
      //     results: verses,
      //     history: state.history,
      //   )),
      // );
    }
  }

  void _onSaveInHistory(
    _SaveInHistory event,
    Emitter<BSearchbarState> emit,
  ) {
    if (!event.result.success) return;
    final entry = HistoryData(ref: event.result.ref, time: DateTime.now());
    final updated = [entry, ...state.history];
    final current = state;
    emit(switch (current) {
      SearchIdle() => SearchIdle(history: updated),
      SearchReferenceResult() =>
        SearchReferenceResult(ref: current.ref, history: updated),
      SearchStringResult() =>
        SearchStringResult(results: current.results, history: updated),
      SearchError() => SearchError(message: current.message, history: updated),
    });
  }

  void _onDeleteHistoryItem(
    DeleteHistoryItem event,
    Emitter<BSearchbarState> emit,
  ) {
    final updated = List.of(state.history)..removeAt(event.index);
    // Preserve the current result state, only update history.
    final current = state;
    emit(switch (current) {
      SearchIdle() => SearchIdle(history: updated),
      SearchReferenceResult() =>
        SearchReferenceResult(ref: current.ref, history: updated),
      SearchStringResult() =>
        SearchStringResult(results: current.results, history: updated),
      SearchError() => SearchError(message: current.message, history: updated),
    });
  }

  void _onUpdateRef(
    BSearchbarUpdateRef event,
    Emitter<BSearchbarState> emit,
  ) {
    final current = state;
    if (current is! SearchReferenceResult) return;
    emit(SearchReferenceResult(ref: event.ref, history: current.history));
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

class _SaveInHistory extends BSearchbarEvent {
  final NavigationFeedback result;
  const _SaveInHistory(this.result);
}
