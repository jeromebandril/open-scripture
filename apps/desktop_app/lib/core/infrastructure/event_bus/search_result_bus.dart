import 'dart:async';

import '../../../shared/domain/entities/bible_ref.dart';

enum IntentSource { searchbar }

class SearchResultBus {
  final _c = StreamController<SearchResultEvent>.broadcast();
  Stream<SearchResultEvent> get stream => _c.stream;
  void emit(SearchResultEvent e) => _c.add(e);
  Future<void> close() => _c.close();
}

sealed class SearchResultEvent {
  final IntentSource? source;
  const SearchResultEvent({this.source});
}

class SearchResultSuccess extends SearchResultEvent {
  final BibleRef ref;
  const SearchResultSuccess({required this.ref, super.source});
}

class SearchResultError extends SearchResultEvent {
  final String message;
  const SearchResultError({required this.message, super.source});
}
