part of 'three_tap_navigator_cubit.dart';

enum ThreeTapNavigatorStatus { init, error, loaded }

enum BookLoadType { localized, defaulted }

class ThreeTapNavigatorState extends Equatable {
  const ThreeTapNavigatorState({
    this.status = ThreeTapNavigatorStatus.init,
    this.ref,
    this.books = const [],
    this.maxChapter = 0,
    this.maxVerse = 0,
    this.loadType = BookLoadType.defaulted,
  });

  final ThreeTapNavigatorStatus status;
  final BibleRef? ref;
  final List<LocalizedBook> books;
  final int maxChapter;
  final int maxVerse;
  final BookLoadType loadType;

  ThreeTapNavigatorState copyWith({
    ThreeTapNavigatorStatus? status,
    BibleRef? ref,
    List<LocalizedBook>? books,
    int? maxChapter,
    int? maxVerse,
    BookLoadType? loadType,
  }) {
    return ThreeTapNavigatorState(
      status: status ?? this.status,
      ref: ref ?? this.ref,
      books: books ?? this.books,
      maxChapter: maxChapter ?? this.maxChapter,
      maxVerse: maxVerse ?? this.maxVerse,
      loadType: loadType ?? this.loadType,
    );
  }

  @override
  List<Object?> get props =>
      [status, ref, books, maxChapter, maxVerse, loadType];
}
