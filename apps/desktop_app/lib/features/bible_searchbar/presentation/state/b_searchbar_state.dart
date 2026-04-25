part of 'b_searchbar_bloc.dart';

sealed class BSearchbarState extends Equatable {
  final List<HistoryData> history;
  const BSearchbarState({required this.history});
}

class SearchIdle extends BSearchbarState {
  const SearchIdle({required super.history});

  @override
  List<Object?> get props => [history];
}

class SearchReferenceResult extends BSearchbarState {
  final BibleRef ref;
  const SearchReferenceResult({
    required this.ref,
    required super.history,
  });

  @override
  List<Object?> get props => [ref, history];
}

class SearchStringResult extends BSearchbarState {
  final List<BibleRef> results;
  const SearchStringResult({
    required this.results,
    required super.history,
  });

  @override
  List<Object?> get props => [results, history];
}

class SearchError extends BSearchbarState {
  final String message;
  const SearchError({
    required this.message,
    required super.history,
  });

  @override
  List<Object?> get props => [message, history];
}
