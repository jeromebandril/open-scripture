import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/core/infrastructure/event_bus/resolved_search_intent_bus.dart';
import 'package:open_scripture/core/infrastructure/event_bus/search_result_bus.dart';
import 'package:open_scripture/features/bible_searchbar/search/domain/entities/search_intent.dart';
import 'package:open_scripture/features/bible_searchbar/search/domain/repositories/search_repository.dart';
import 'package:open_scripture/features/bible_searchbar/search/domain/search_intent_resolver.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repo;
  final SearchIntentResolver _resolver;
  final ResolvedSearchIntentBus _searchIntentBus;
  final SearchResultBus _searchResultBus;

  SearchBloc({
    required SearchRepository repo,
    required SearchIntentResolver intentResolver,
    required ResolvedSearchIntentBus searchIntentBus,
    required SearchResultBus searchResultBus,
  })  : _searchIntentBus = searchIntentBus,
        _searchResultBus = searchResultBus,
        _repo = repo,
        _resolver = intentResolver,
        super(const SearchIdle()) {
    on<SearchParseIntent>(_onParseIntent);
    on<SearchUpdateRef>(_onUpdateRef);
    on<_SearchResultReceived>(_onSearchResultReceived);

    _searchResultBus.stream.listen((event) {
      // print('search bloc received search result event: $event');
      if (event.source != IntentSource.searchbar) return;
      add(_SearchResultReceived(event));
    });
  }

  Future<void> _onParseIntent(
    SearchParseIntent event,
    Emitter<SearchState> emit,
  ) async {
    final intent = _resolver.resolve(event.query);
    switch (intent) {
      case ReferenceIntent():
        final result = await _repo.parse(intent.rawQuery);
        result.fold(
          (f) => emit(SearchError(
            message: f.details,
            errorCount: state.errorCount + 1,
          )),
          (ref) {
            print('parsed ref: $ref');
            // I should emit anything here right bro?
            // emit(SearchReferenceResult(ref: ref));
            _searchIntentBus.emit(ResolvedPartialRefIntent(ref: ref));
          },
        );
        break;

      case VerseNumberIntent():
        // VerseNumberIntent refines an existing reference result.
        // If there is no prior reference in state, the intent is a no-op.
        final current = state;
        if (current is! SearchReferenceResult) return;
        final refinedRef = current.ref.copyWith(
            verseStart: () => intent.verseNumber, verseEnd: () => null);
        emit(SearchReferenceResult(ref: refinedRef));
        _searchIntentBus
            .emit(ResolvedRefIntent(ref: refinedRef, isVerseLevel: true));
        break;

      case StringSearchIntent():
      // TODO: implement string search
    }
  }

  void _onUpdateRef(
    SearchUpdateRef event,
    Emitter<SearchState> emit,
  ) {
    final current = state;
    if (current is! SearchReferenceResult) return;
    emit(SearchReferenceResult(ref: event.ref));
  }

  void _onSearchResultReceived(
    _SearchResultReceived event,
    Emitter<SearchState> emit,
  ) {
    final result = event.result;
    switch (result) {
      case SearchResultError(:final message):
        emit(SearchError(
          message: message,
          errorCount:
              state is SearchError ? (state as SearchError).errorCount + 1 : 1,
        ));
      case SearchResultSuccess(:final ref):
        emit(SearchReferenceResult(ref: ref));
    }
  }
}

class _SearchResultReceived extends SearchEvent {
  final SearchResultEvent result;
  const _SearchResultReceived(this.result);
}
