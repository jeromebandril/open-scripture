import 'package:equatable/equatable.dart';

class BibleRef extends Equatable {
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
  String toString() {
    return '$bookUsfxId $chapter${verseStart != null ? ':$verseStart' : ''}${verseEnd != null ? '-$verseEnd' : ''}';
  }

  @override
  List<Object?> get props => [bookUsfxId, chapter, verseStart, verseEnd];
}
