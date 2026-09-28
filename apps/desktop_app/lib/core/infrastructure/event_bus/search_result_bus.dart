import '../../../shared/domain/entities/bible_ref.dart';
import 'event_bus.dart';

enum IntentSource { searchbar }

class SearchResultBus extends EventBus<SearchResultEvent> {}

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
