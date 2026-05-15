part of 'b_searchbar_bloc.dart';

sealed class BSearchbarState extends Equatable {
  final List<HistoryData> history;
  final int errorCount;
  const BSearchbarState({required this.history, this.errorCount = 0});
}

class SearchIdle extends BSearchbarState {
  const SearchIdle({required super.history, super.errorCount = 0});

  @override
  List<Object?> get props => [history, errorCount];
}

class SearchReferenceResult extends BSearchbarState {
  final BibleRef ref;
  const SearchReferenceResult({
    required this.ref,
    required super.history,
    super.errorCount = 0,
  });

  @override
  List<Object?> get props => [ref, history, errorCount];
}

class SearchStringResult extends BSearchbarState {
  final List<BibleRef> results;
  const SearchStringResult({
    required this.results,
    required super.history,
    super.errorCount = 0,
  });

  @override
  List<Object?> get props => [results, history, errorCount];
}

class SearchError extends BSearchbarState {
  final String message;
  const SearchError({
    required this.message,
    required super.history,
    super.errorCount = 0,
  });

  @override
  List<Object?> get props => [message, history, errorCount];
}
