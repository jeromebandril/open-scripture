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
    this.errorMessage,
    this.selectedBibleIndex,
    this.repoType = BibleRepositoryType.localDatabase,
  });

  final MyLibraryStatus status;
  final List<BibleTranslation> bibles;
  final int? selectedBibleIndex;
  final String? errorMessage;
  final BibleRepositoryType repoType;

  MyLibraryState copywith({
    MyLibraryStatus? status,
    List<BibleTranslation>? bibles,
    String? Function()? errorMessage,
    int? Function()? selectedBibleIndex,
    BibleRepositoryType? repoType,
  }) {
    return MyLibraryState(
      status: status ?? this.status,
      bibles: bibles ?? this.bibles,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      selectedBibleIndex: selectedBibleIndex != null
          ? selectedBibleIndex()
          : this.selectedBibleIndex,
      repoType: repoType ?? this.repoType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        bibles,
        selectedBibleIndex,
        errorMessage,
        repoType,
      ];
}
