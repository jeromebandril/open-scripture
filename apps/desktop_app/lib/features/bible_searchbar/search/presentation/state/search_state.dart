part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  final int errorCount;
  const SearchState({this.errorCount = 0});
}

class SearchIdle extends SearchState {
  const SearchIdle({super.errorCount = 0});

  @override
  List<Object?> get props => [errorCount];
}

class SearchReferenceResult extends SearchState {
  final BibleRef ref;
  const SearchReferenceResult({
    required this.ref,
    super.errorCount = 0,
  });

  @override
  List<Object?> get props => [ref, errorCount];
}

class SearchStringResult extends SearchState {
  final List<BibleRef> results;
  const SearchStringResult({
    required this.results,
    super.errorCount = 0,
  });

  @override
  List<Object?> get props => [results, errorCount];
}

class SearchError extends SearchState {
  final String message;
  const SearchError({
    required this.message,
    super.errorCount = 0,
  });

  @override
  List<Object?> get props => [message, errorCount];
}
