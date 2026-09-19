import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../shared/data/datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import '../../../../../shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import '../../../../../shared/data/models/bible_install_dto.dart';
import '../../../../../shared/data/models/verse_segment_dto.dart';
import '../../../../../shared/domain/entities/bible_id.dart';
import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/entities/bible_translation.dart';
import '../../../../../shared/domain/entities/verse.dart';
import '../../../../../shared/error/exception.dart';
import '../../../../../shared/error/failure.dart';
import '../../../../pericopes_mgr/data/datasources/pericope_datasource.dart';
import '../../../../pericopes_mgr/domain/entities/pericope.dart';
import '../../domain/repositories/bible_pane_repository.dart';
import '../../error/bible_failures.dart';

class BiblePaneRepositoryImpl implements BiblePaneRepository {
  final BibleContentDatasource _contentDatasource;
  final BibleCatalogDatasource _catalogDatasource;
  final PericopeDatasource? _pericopeDatasource;

  const BiblePaneRepositoryImpl({
    required BibleContentDatasource contentDatasource,
    required BibleCatalogDatasource catalogDatasource,
    PericopeDatasource? pericopeDatasource,
  })  : _pericopeDatasource = pericopeDatasource,
        _contentDatasource = contentDatasource,
        _catalogDatasource = catalogDatasource;

  @override
  TaskEither<Failure, BibleTranslation> getBible({
    required BibleId bibleId,
  }) {
    return TaskEither.tryCatch(
      () async =>
          (await _catalogDatasource.getBible(bibleId.externalId)).toDomain(),
      (error, st) => switch (error) {
        NotFoundException e => BibleNotFoundFailure(cause: e, stackTrace: st),
        _ => UnexpectedFailure(cause: error, stackTrace: st),
      },
    );
  }

  @override
  TaskEither<Failure, List<Verse>> getVerses({
    required BibleId bibleId,
    required List<BibleRef> refs,
  }) {
    return TaskEither.tryCatch(
      () async {
        final versesByRef = await _contentDatasource.getVerses(
          bibleId.externalId,
          refs,
        );

        return versesByRef.entries.map((entry) {
          final segmentsDtos = entry.value;

          return Verse(
            translationId: bibleId.externalId,
            ref: entry.key,
            segments: segmentsDtos.map((dto) => dto.toDomain()).toList(),
          );
        }).toList();
      },
      (error, st) => switch (error) {
        NotFoundException e =>
          ChapterUnavailableFailure(cause: e, stackTrace: st),
        ServerException e =>
          ChapterUnavailableFailure(cause: e, stackTrace: st),
        NetworkException e => NetworkFailure(cause: e, stackTrace: st),
        SwordException e => SwordUnavailableFailure(cause: e, stackTrace: st),
        _ => UnexpectedFailure(cause: error, stackTrace: st),
      },
    );
  }

  @override
  TaskEither<Failure, List<Verse>> getChapter({
    required BibleId bibleId,
    required BibleRef ref,
  }) {
    return TaskEither.tryCatch(
      () async {
        final dtos = await _contentDatasource.getChapter(
          bibleId.externalId,
          ref.book,
          ref.chapter,
        );

        final grouped = <int, List<VerseSegmentDto>>{};
        for (final row in dtos) {
          grouped.putIfAbsent(row.verseNumber, () => []).add(row);
        }

        final verses = grouped.entries.map((entry) {
          final segmentsDtos = entry.value
            ..sort((a, b) => a.segmentIndex.compareTo(b.segmentIndex));

          return Verse(
            translationId: bibleId.externalId,
            ref: BibleRef(
              book: ref.book,
              chapter: ref.chapter,
              verseStart: entry.key,
            ),
            segments: segmentsDtos.map((dto) => dto.toDomain()).toList(),
          );
        }).toList();

        if (_pericopeDatasource == null) {
          debugPrint(
              'Pericope datasource not available, skipping pericope overlay');
          return verses;
        }

        final pericopes = await _loadPericopes(bibleId, ref);
        return attachPericopes(verses, pericopes);
      },
      (error, st) => switch (error) {
        NotFoundException e =>
          ChapterUnavailableFailure(cause: e, stackTrace: st),
        ServerException e =>
          ChapterUnavailableFailure(cause: e, stackTrace: st),
        NetworkException e => NetworkFailure(cause: e, stackTrace: st),
        SwordException e => SwordUnavailableFailure(cause: e, stackTrace: st),
        _ => UnexpectedFailure(cause: error, stackTrace: st),
      },
    );
  }

  List<Verse> attachPericopes(List<Verse> verses, List<Pericope> pericopes) {
    debugPrint(
        'Attaching ${pericopes.length} pericopes to ${verses.length} verses');
    if (verses.isEmpty || pericopes.isEmpty) return verses;

    final byVerse = <int, Pericope>{};
    for (final p in pericopes) {
      // Versification differences: snap to the first verse that exists
      // at or after the pericope's start, or skip if there is none.
      final target =
          verses.firstWhereOrNull((v) => v.ref.verseStart! >= p.startVerse);
      if (target != null) byVerse.putIfAbsent(target.ref.verseStart!, () => p);
    }

    final p = verses.map((v) {
      final p = byVerse[v.ref.verseStart];
      final hasSourceHeading = v.segments.any((s) => s.heading != null);
      // The Bible's own heading wins over the overlay.
      return p == null || hasSourceHeading ? v : v.copyWith(heading: p.title);
    }).toList();
    debugPrint(p.toString());
    return p;
  }

  Future<List<Pericope>> _loadPericopes(BibleId bibleId, BibleRef ref) async {
    if (_pericopeDatasource == null) return const [];
    try {
      return await _pericopeDatasource.getForChapter(
        bibleId.externalId,
        ref.book,
        ref.chapter,
      );
    } catch (e, st) {
      debugPrint('Pericope load failed: $e\n$st');
      return const [];
    }
  }
}
