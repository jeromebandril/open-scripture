import 'package:equatable/equatable.dart';

class BibleRef extends Equatable {
  static const _unset = Object();

  final String bookOsisId;
  final int chapter;
  final int? verseStart;
  final int? verseEnd;

  const BibleRef({
    required this.bookOsisId,
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
      bookOsisId: bookOsisId ?? this.bookOsisId,
      chapter: chapter ?? this.chapter,
      verseStart:
          identical(verseStart, _unset) ? this.verseStart : verseStart as int?,
      verseEnd:
          identical(verseEnd, _unset) ? this.verseStart : verseEnd as int?,
    );
  }

  @override
  List<Object?> get props => [bookOsisId, chapter, verseStart, verseEnd];
}
