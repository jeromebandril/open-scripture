part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchParseIntent extends SearchEvent {
  final String query;

  const SearchParseIntent(this.query);

  @override
  List<Object> get props => [query];
}

/// This is an hacky solution for updating internal state's ref manually when a verse is navigated to from History.
/// Until a better solution is implemented, this is needed because History set chapter content directly
/// without going through the search process, making the searchbar state be always out of sync,
/// which breaks VerseNumberIntent in _parseIntent() for example (see [SearchBloc]).
class SearchUpdateRef extends SearchEvent {
  final BibleRef ref;
  const SearchUpdateRef(this.ref);

  @override
  List<Object> get props => [ref];
}
