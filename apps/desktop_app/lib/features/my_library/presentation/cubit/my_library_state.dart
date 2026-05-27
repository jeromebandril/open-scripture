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
  });

  final MyLibraryStatus status;
  final List<BibleMeta> bibles;
  final int? selectedBibleIndex;
  final String? errorMessage;

  MyLibraryState copywith(
      {MyLibraryStatus? status,
      List<BibleMeta>? bibles,
      String? Function()? errorMessage,
      int? Function()? selectedBibleIndex}) {
    return MyLibraryState(
      status: status ?? this.status,
      bibles: bibles ?? this.bibles,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      selectedBibleIndex: selectedBibleIndex != null
          ? selectedBibleIndex()
          : this.selectedBibleIndex,
    );
  }

  @override
  List<Object?> get props => [status, bibles, selectedBibleIndex, errorMessage];
}
