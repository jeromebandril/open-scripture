import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/core/infrastructure/event_bus/resolved_search_intent_bus.dart';
import 'package:open_scripture/features/bible_searchbar/search/domain/entities/search_intent.dart';
import 'package:open_scripture/features/bible_searchbar/search/domain/search_intent_resolver.dart';
import 'package:open_scripture/shared/entities/bible_ref.dart';

import '../../domain/repositories/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required SearchRepository repo,
    required SearchIntentResolver resolver,
    required ResolvedSearchIntentBus searchIntentBus,
  })  : _searchIntentBus = searchIntentBus,
        _repo = repo,
        _resolver = resolver,
        super(const SearchIdle()) {
    on<SearchParseIntent>(_onParseIntent);
    on<SearchUpdateRef>(_onUpdateRef);
  }

  final SearchRepository _repo;
  final SearchIntentResolver _resolver;
  final ResolvedSearchIntentBus _searchIntentBus;

  Future<void> _onParseIntent(
    SearchParseIntent event,
    Emitter<SearchState> emit,
  ) async {
    final intent = _resolver.resolve(event.query);
    switch (intent) {
      case ReferenceIntent():
        final result = await _repo.parseBibleRef(intent.rawQuery);
        result.fold(
          (f) => emit(SearchError(
            message: f.details,
            errorCount: state.errorCount + 1,
          )),
          (ref) {
            emit(SearchReferenceResult(ref: ref));
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
        emit(SearchReferenceResult(ref: refinedRef));
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

  void _onUpdateRef(
    SearchUpdateRef event,
    Emitter<SearchState> emit,
  ) {
    final current = state;
    if (current is! SearchReferenceResult) return;
    emit(SearchReferenceResult(ref: event.ref));
  }
}
