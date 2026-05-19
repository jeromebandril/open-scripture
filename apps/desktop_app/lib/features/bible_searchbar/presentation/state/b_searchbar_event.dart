part of 'b_searchbar_bloc.dart';

sealed class BSearchbarEvent extends Equatable {
  const BSearchbarEvent();

  @override
  List<Object> get props => [];
}

class BSearchbarParseIntent extends BSearchbarEvent {
  final String query;

  const BSearchbarParseIntent(this.query);

  @override
  List<Object> get props => [query];
}

class DeleteHistoryItem extends BSearchbarEvent {
  final int index;
  const DeleteHistoryItem(this.index);

  @override
  List<Object> get props => [index];
}

/// This is an hacky solution for updating internal state's ref manually when a verse is navigated to from History.
/// Until a better solution is implemented, this is needed because History set chapter content directly
/// without going through the search process, making the searchbar state be always out of sync,
/// which breaks VerseNumberIntent in _parseIntent() for example (see [BSearchbarBloc]).
class BSearchbarUpdateRef extends BSearchbarEvent {
  final BibleRef ref;
  const BSearchbarUpdateRef(this.ref);

  @override
  List<Object> get props => [ref];
}
