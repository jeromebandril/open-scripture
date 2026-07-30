part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  final int errorCount;
  const SearchState({this.errorCount = 0});
  @override
  List<Object?> get props => [errorCount];
}

class SearchIdle extends SearchState {
  const SearchIdle();
  @override
  List<Object?> get props => [...super.props];
}

class SearchReferenceResult extends SearchState {
  final BibleRef ref;
  const SearchReferenceResult({required this.ref});

  @override
  List<Object?> get props => [...super.props, ref];
}

class SearchMultipleReferenceResult extends SearchState {
  final List<BibleRef> refs;
  const SearchMultipleReferenceResult({required this.refs});
  @override
  List<Object?> get props => [...super.props, refs];
}

class SearchStringResult extends SearchState {
  final List<BibleRef> results;
  const SearchStringResult({required this.results});
  @override
  List<Object?> get props => [...super.props, results];
}

class SearchError extends SearchState {
  final String message;
  const SearchError({super.errorCount, required this.message});
  @override
  List<Object?> get props => [...super.props, message];
}
