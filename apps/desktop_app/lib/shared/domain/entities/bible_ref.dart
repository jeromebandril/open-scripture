import 'package:equatable/equatable.dart';

class BibleRef extends Equatable implements Comparable<BibleRef> {
  static const _unset = Object();

  final String bookUsfxId;
  final int chapter;
  final int? verseStart;
  final int? verseEnd;

  const BibleRef({
    required this.bookUsfxId,
    required this.chapter,
    this.verseStart,
    this.verseEnd,
  });

  bool contains(BibleRef ref) {
    final start = ref.verseStart;
    final end = ref.verseEnd;
    return (end == null && this.verseStart == start) ||
        (end != null &&
            start != null &&
            this.verseStart! >= start &&
            this.verseStart! <= end);
  }

  BibleRef copyWith({
    String? bookOsisId,
    int? chapter,
    Object? verseStart = _unset,
    Object? verseEnd = _unset,
  }) {
    return BibleRef(
      bookUsfxId: bookOsisId ?? this.bookUsfxId,
      chapter: chapter ?? this.chapter,
      verseStart:
          identical(verseStart, _unset) ? this.verseStart : verseStart as int?,
      verseEnd:
          identical(verseEnd, _unset) ? this.verseStart : verseEnd as int?,
    );
  }

  @override
  int compareTo(BibleRef other) {
    final bookCmp = bookUsfxId.compareTo(other.bookUsfxId);
    if (bookCmp != 0) return bookCmp;

    final chapterCmp = chapter.compareTo(other.chapter);
    if (chapterCmp != 0) return chapterCmp;

    final verseCmp = (verseStart ?? 0).compareTo(other.verseStart ?? 0);
    if (verseCmp != 0) return verseCmp;

    return (verseEnd ?? 0).compareTo(other.verseEnd ?? 0);
  }

  @override
  String toString() {
    return '$bookUsfxId $chapter${verseStart != null ? ':$verseStart' : ''}${verseEnd != null ? '-$verseEnd' : ''}';
  }

  @override
  List<Object?> get props => [bookUsfxId, chapter, verseStart, verseEnd];
}
