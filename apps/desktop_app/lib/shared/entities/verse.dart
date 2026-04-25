import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:open_scripture/shared/entities/bible_ref.dart';
import 'package:open_scripture/shared/entities/verse_segment.dart';
import 'package:open_scripture/shared/typedefs.dart';

class Verse extends Equatable {
  final BibleId? bibleId;
  final BibleRef ref;
  final List<VerseSegment> segments;

  const Verse({
    required this.ref,
    required this.segments,
    this.bibleId,
  });

  static SplayTreeMap<BibleRef, Verse> groupMixedSegmentsIntoVerses(
      List<VerseSegment> segments) {
    // Copy + sort to ensure stable output even if input is unordered.
    final sorted = [...segments]..sort((a, b) {
        final bookCmp = a.ref.bookUsfxId.compareTo(b.ref.bookUsfxId);
        if (bookCmp != 0) return bookCmp;

        final chapCmp = a.ref.chapter.compareTo(b.ref.chapter);
        if (chapCmp != 0) return chapCmp;

        final verseCmp = a.ref.verseStart!.compareTo(b.ref.verseStart!);
        if (verseCmp != 0) return verseCmp;

        return a.segmentIndex.compareTo(b.segmentIndex);
      });

    // Group
    final map = SplayTreeMap<BibleRef, List<VerseSegment>>();

    for (final seg in sorted) {
      (map[seg.ref] ??= []).add(seg);
    }

    final result = SplayTreeMap<BibleRef, Verse>();

    map.forEach((ref, segs) {
      result[ref] = Verse(
        bibleId: segs.first.bibleId,
        ref: ref,
        segments: List.unmodifiable(segs),
      );
    });

    return result;
  }

  String get text => segments.map((s) => s.textContent).join();

  @override
  List<Object?> get props => [ref, segments, bibleId];
}
