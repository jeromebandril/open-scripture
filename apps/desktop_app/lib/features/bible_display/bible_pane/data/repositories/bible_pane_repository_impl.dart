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
import '../../domain/error/bible_failures.dart';
import '../../domain/repositories/bible_pane_repository.dart';

class BiblePaneRepositoryImpl implements BiblePaneRepository {
  final BibleContentDatasource _contentDatasource;
  final BibleCatalogDatasource _catalogDatasource;

  const BiblePaneRepositoryImpl({
    required BibleContentDatasource contentDatasource,
    required BibleCatalogDatasource catalogDatasource,
  })  : _contentDatasource = contentDatasource,
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
    // TODO: implement this
    throw UnimplementedError();
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

        return verses;
      },
      (error, st) => switch (error) {
        NotFoundException e =>
          ChapterUnavailableFailure(cause: e, stackTrace: st),
        ServerException e =>
          ChapterUnavailableFailure(cause: e, stackTrace: st),
        NetworkException e =>
          ChapterUnavailableFailure(cause: e, stackTrace: st),
        SwordException e => SwordUnavailableFailure(cause: e, stackTrace: st),
        _ => UnexpectedFailure(cause: error, stackTrace: st),
      },
    );
  }
}
