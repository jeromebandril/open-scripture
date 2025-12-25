import 'package:equatable/equatable.dart';

import 'bible_ref.dart';
import 'verse_span.dart';

class VerseSegment extends Equatable {
  final BibleRef ref;
  final int segmentIndex;
  final bool paragraphStart;
  final String textContent;
  final String? subtitle;
  final List<VerseSpan> spans;

  const VerseSegment({
    required this.ref,
    required this.segmentIndex,
    required this.paragraphStart,
    required this.textContent,
    required this.subtitle,
    required this.spans,
  });

  // factory VerseSegment.fromDatabase(Map<String, dynamic> map) {
  //   return VerseSegments(
  //     id: map['id'],
  //     paragraphId: map['paragraph_id'],
  //     verseNumber: map['number'],
  //     verseText: map['text'],
  //     chapterNumber: map['chapter_number'],
  //   );
  // }

  // EVerse toDomain() {
  //   return EVerse(
  //     paragraphId: paragraphId,
  //     verseNumber: verseNumber,
  //     verseText: verseText,
  //     chapterNumber: chapterNumber,
  //   );
  // }

  @override
  List<Object?> get props => [
        ref,
        segmentIndex,
        paragraphStart,
        textContent,
        subtitle,
        spans,
      ];
}
