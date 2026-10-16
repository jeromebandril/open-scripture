import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../../shared/domain/entities/bible_id.dart';
import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/entities/bible_translation.dart';
import '../../../../../shared/domain/entities/verse.dart';

typedef ParallelBibleMap = Map<BibleId, BibleData>;

/// The content of a Bible pane: one [BibleData] per Bible/translation shown
/// side by side, plus the combined list of verse refs across all of them.
class ParallelBibleConfig extends Equatable {
  final ParallelBibleMap _dataById;

  /// Union of the refs of every Bible/translation.
  ///
  /// Needed because translations can have different chapter lengths.
  final List<BibleRef> refs;

  const ParallelBibleConfig._(this._dataById, this.refs);

  /// Creates a config from [dataById].
  ///
  /// [refs] are sorted by default. Pass [preserveOrder] to keep them in
  /// first-seen order instead.
  factory ParallelBibleConfig.from(
    ParallelBibleMap dataById, {
    bool preserveOrder = false,
  }) {
    final unmodifiableData = Map<BibleId, BibleData>.unmodifiable(dataById);
    final unionRefs = _unionOfRefs(
      unmodifiableData,
      preserveOrder: preserveOrder,
    );

    return ParallelBibleConfig._(
      unmodifiableData,
      List.unmodifiable(unionRefs),
    );
  }

  static const ParallelBibleConfig empty =
      ParallelBibleConfig._(<BibleId, BibleData>{}, []);

  Iterable<BibleId> get bibleIds => _dataById.keys;

  /// Unmodifiable view of the underlying data.
  ParallelBibleMap get asMap => _dataById;

  bool get isContentEmpty => _dataById.values.every((data) => data.hasNoVerses);

  BibleData? dataFor(BibleId id) => _dataById[id];

  /// Returns the refs from [refs] that fall within a range.
  ///
  /// - With [end]: every ref between [start] and [end] (inclusive), compared
  ///   with [BibleRef.compareTo].
  /// - Without [end]: if [start] spans several verses (has a `verseEnd`),
  ///   every ref whose verse number lies within that span; otherwise just
  ///   [start] itself.
  List<BibleRef> getRefsInRange(BibleRef start, {BibleRef? end}) {
    if (end != null) {
      return refs
          .where((ref) => ref.compareTo(start) >= 0 && ref.compareTo(end) <= 0)
          .toList();
    }

    final lastVerse = start.verseEnd;
    if (lastVerse == null) return [start];

    final firstVerse = start.verseStart!;
    return refs
        .where(
          (ref) =>
              ref.verseStart! >= firstVerse && ref.verseStart! <= lastVerse,
        )
        .toList();
  }

  static List<BibleRef> _unionOfRefs(
    ParallelBibleMap dataById, {
    required bool preserveOrder,
  }) {
    final allRefs = dataById.values.expand(
      (data) => data.verses?.keys ?? const <BibleRef>[],
    );

    return preserveOrder
        ? allRefs.toSet().toList() // Set keeps first-seen order
        : SplayTreeSet<BibleRef>.of(allRefs).toList();
  }

  @override
  List<Object?> get props => [_dataById, refs];
}

/// A single Bible/translation and, if loaded, its verses.
class BibleData extends Equatable {
  final BibleTranslation translation;

  /// Verses keyed by ref, in the order they were loaded.
  /// `null` if the verses haven't been loaded.
  final Map<BibleRef, Verse>? verses;

  const BibleData({required this.translation, this.verses});

  bool get hasNoVerses => verses?.isEmpty ?? true;

  BibleData withVerses(List<Verse>? newVerses) => BibleData(
        translation: translation,
        verses: newVerses == null
            ? null
            : {for (final verse in newVerses) verse.ref: verse},
      );

  @override
  List<Object?> get props => [translation, verses];
}
