import 'package:equatable/equatable.dart';
import 'bible_book.dart';

/// Verse coordinate, or used also for canonical query object
class BibleRef extends Equatable implements Comparable<BibleRef> {
  final BibleBook book;
  final int chapter;
  final int? verseStart;
  final int? verseEnd;

  const BibleRef({
    required this.book,
    required this.chapter,
    this.verseStart,
    this.verseEnd,
  })  : assert(chapter > 0, 'Chapter must be strictly positive.'),
        assert(verseStart == null || verseStart > 0,
            'Verse must be strictly positive.'),
        assert(verseEnd == null || verseStart != null,
            'Cannot have verseEnd without verseStart.'),
        assert((verseStart ?? 0) <= (verseEnd ?? verseStart ?? 0),
            'verseEnd cannot precede verseStart.');

  bool get isRange => verseEnd != null && verseEnd != verseStart;
  bool get isWholeChapter => verseStart == null;

  BibleRef copyWith({
    BibleBook? book,
    int? chapter,
    int? Function()? verseStart,
    int? Function()? verseEnd,
  }) {
    return BibleRef(
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verseStart: verseStart != null ? verseStart() : this.verseStart,
      verseEnd: verseEnd != null ? verseEnd() : this.verseStart,
    );
  }

  bool contains(BibleRef other) {
    // 1. Must be the exact same book.
    if (book != other.book) return false;

    // 2. Must be the exact same chapter.
    if (chapter != other.chapter) return false;

    // 3. If 'this' is the whole chapter, it automatically contains 'other'
    // (since we already verified the book and chapter match).
    if (isWholeChapter) return true;

    // 4. If 'this' is a specific verse/range, but 'other' is a whole chapter,
    // 'this' cannot contain 'other'.
    if (other.isWholeChapter) return false;

    // 5. Both have specific verses. Normalize null verseEnd values to verseStart
    // for easy boundary comparison.
    final thisStart = verseStart!;
    final thisEnd = verseEnd ?? verseStart!;

    final otherStart = other.verseStart!;
    final otherEnd = other.verseEnd ?? other.verseStart!;

    // 'other' is contained if its start is >= our start, and its end is <= our end.
    return otherStart >= thisStart && otherEnd <= thisEnd;
  }

  @override
  String toString() {
    return '${book.usfm} ${toStringChapterAndVerse()}';
  }

  String toStringChapterAndVerse() {
    return '$chapter:$verseStart${verseEnd != null ? '-$verseEnd' : ''}';
  }

  @override
  List<Object?> get props => [book, chapter, verseStart, verseEnd];

  @override
  int compareTo(BibleRef other) {
    if (book.osisIndex != other.book.osisIndex) {
      return book.osisIndex.compareTo(other.book.osisIndex);
    }
    if (chapter != other.chapter) {
      return chapter.compareTo(other.chapter);
    }
    if (verseStart != other.verseStart) {
      return (verseStart ?? 0).compareTo(other.verseStart ?? 0);
    }
    return (verseEnd ?? 0).compareTo(other.verseEnd ?? 0);
  }
}
