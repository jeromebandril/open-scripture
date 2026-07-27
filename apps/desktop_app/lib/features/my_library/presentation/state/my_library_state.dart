part of 'my_library_cubit.dart';

enum MyLibraryStatus {
  initial,
  loading,
  ready,
  error,
}

final class MyLibraryState extends Equatable {
  const MyLibraryState({
    this.status = MyLibraryStatus.initial,
    this.bibles = const [],
    this.uninstallingBibles = const [],
    this.errorMessage,
    this.selectedBibleIndex,
    this.repoType = BibleRepositoryType.localDatabase,
    this.filterQuery = '',
  });

  final MyLibraryStatus status;
  final List<BibleTranslation> bibles;
  final List<BibleTranslation> uninstallingBibles;
  final int? selectedBibleIndex;
  final String? errorMessage;
  final BibleRepositoryType repoType;
  final String filterQuery;

  List<BibleTranslation> get filteredBibles {
    if (filterQuery.isEmpty) return bibles;
    final q = filterQuery.toLowerCase();
    return bibles.where((b) {
      return b.name.toLowerCase().contains(q) ||
          b.abbreviation.toLowerCase().contains(q) ||
          (b.langEngName?.toLowerCase().contains(q) ?? false) ||
          (b.langNativeName?.toLowerCase().contains(q) ?? false) ||
          (b.langIsoCode?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  MyLibraryState copywith({
    MyLibraryStatus? status,
    List<BibleTranslation>? bibles,
    String? Function()? errorMessage,
    int? Function()? selectedBibleIndex,
    BibleRepositoryType? repoType,
    String? filterQuery,
    List<BibleTranslation>? uninstallingBibles,
  }) {
    return MyLibraryState(
      status: status ?? this.status,
      bibles: bibles ?? this.bibles,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      selectedBibleIndex: selectedBibleIndex != null
          ? selectedBibleIndex()
          : this.selectedBibleIndex,
      repoType: repoType ?? this.repoType,
      filterQuery: filterQuery ?? this.filterQuery,
      uninstallingBibles: uninstallingBibles ?? this.uninstallingBibles,
    );
  }

  @override
  List<Object?> get props => [
        status,
        bibles,
        selectedBibleIndex,
        errorMessage,
        repoType,
        filterQuery,
        uninstallingBibles,
      ];
}
