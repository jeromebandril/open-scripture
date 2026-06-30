import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../../shared/domain/entities/bible_id.dart';
import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/entities/bible_translation.dart';
import '../../../../../shared/domain/entities/verse.dart';

typedef ParallelBibleMap = Map<BibleId, BibleData>;

class ParallelBibleConfig extends Equatable {
  final ParallelBibleMap _config;

  const ParallelBibleConfig._(this._config);

  factory ParallelBibleConfig.from(
    ParallelBibleMap map,
  ) {
    return ParallelBibleConfig._(Map.unmodifiable(map));
  }

  BibleData? getParallelDataByBibleId(BibleId id) => _config[id];

  static const ParallelBibleConfig empty =
      ParallelBibleConfig._(<BibleId, BibleData>{});

  BibleData? operator [](BibleId id) => _config[id];

  Iterable<BibleId> get keys => _config.keys;

  ParallelBibleMap get asMap => Map.unmodifiable(_config);

  bool get isContentEmpty {
    if (_config.isEmpty) return true;

    return _config.values.every(
      (data) => data.verses == null || data.verses!.isEmpty,
    );
  }

  /// "union" understood as union of all [BibleRef] between each bible/translation.
  /// Useful because two bibles/translations can have different chapter lengths
  SplayTreeSet<BibleRef> computeUnion() {
    final union = SplayTreeSet<BibleRef>();

    for (final data in _config.values) {
      final verses = data.verses;
      if (verses == null) continue;

      union.addAll(verses.keys);
    }

    return union;
  }

  /// If end ref is passed, then it compares the objects
  /// otherwise if only start ref is passed, it will
  /// use the field [verseStart] and [verseEnd]
  List<BibleRef> getRefsInRange(
    BibleRef start, {
    BibleRef? end,
  }) {
    final union = computeUnion();

    if (end == null) {
      return start.verseEnd == null
          ? [start]
          : union
              .where((u) =>
                  start.verseStart! <= u.verseStart! &&
                  start.verseEnd! >= u.verseStart!)
              .toList();
    }

    final result = <BibleRef>[];
    for (final ref in union) {
      if (ref.compareTo(start) < 0) continue;
      if (ref.compareTo(end) > 0) break;

      result.add(ref);
    }

    return result;
  }

  @override
  List<Object?> get props => [_config];
}

/// Group of ordered verses per Bible translation
class BibleData extends Equatable {
  final BibleTranslation meta;
  final SplayTreeMap<BibleRef, Verse>? verses;

  const BibleData({required this.meta, this.verses});

  BibleData copyWith({
    BibleTranslation? meta,
    SplayTreeMap<BibleRef, Verse>? Function()? verses,
  }) {
    return BibleData(
      meta: meta ?? this.meta,
      verses: verses != null ? verses() : this.verses,
    );
  }

  static SplayTreeMap<BibleRef, Verse> versesToMap(List<Verse> verses) {
    return SplayTreeMap.fromIterable(
      verses,
      key: (v) => (v as Verse).ref,
      value: (v) => v as Verse,
    );
  }

  @override
  List<Object?> get props => [meta, verses];
}
