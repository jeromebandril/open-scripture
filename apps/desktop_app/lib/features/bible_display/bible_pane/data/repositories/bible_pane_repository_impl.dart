import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import 'package:open_scripture/shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import 'package:open_scripture/shared/data/models/bible_install_dto.dart';
import 'package:open_scripture/shared/data/models/verse_segment_dto.dart';
import 'package:open_scripture/shared/domain/entities/bible_book.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/entities/verse.dart';
import 'package:open_scripture/shared/error/failure.dart';

class BiblePaneRepositoryImpl implements BiblePaneRepository {
  final BibleContentDatasource _contentDatasource;
  final BibleCatalogDatasource _libraryDatasource;

  const BiblePaneRepositoryImpl({
    required BibleContentDatasource contentDatasource,
    required BibleCatalogDatasource catalogDatasource,
  })  : _contentDatasource = contentDatasource,
        _libraryDatasource = catalogDatasource;

  @override
  Future<Either<Failure, BibleTranslation>> getBibleMetadata({
    required BibleId bibleId,
  }) async {
    try {
      final details = await _libraryDatasource.getBible(bibleId);
      return Right(details.toDomain());
    } catch (e) {
      return Left(NoLocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, List<Verse>>> getVersesWithSpans({
    required BibleId bibleId,
    required List<BibleRef> refs,
  }) async {
    // TODO: implement this
    throw UnimplementedError();
    // try {
    //   return Right(await _contentDatasource.getVersesSegments(bibleId, refs));
    // } catch (e) {
    //   return Left(UnknownFailure(details: e.toString()));
    // }
  }

  @override
  Future<Either<Failure, List<Verse>>> getChapterWithSpans({
    required BibleId bibleId,
    required BibleRef ref,
  }) async {
    try {
      final dtos = await _contentDatasource.getChapterWithSpans(
        bibleId,
        ref.book,
        ref.chapter,
      );

      final grouped = <int, List<VerseSegmentDto>>{};
      for (final row in dtos) {
        grouped.putIfAbsent(row.verseNumber, () => []).add(row);
      }

      // Build Verses
      final verses = grouped.entries.map((entry) {
        final segmentsDtos = entry.value
          ..sort((a, b) => a.segmentIndex.compareTo(b.segmentIndex));

        return Verse(
          translationId: bibleId,
          ref: BibleRef(
            book: ref.book,
            chapter: ref.chapter,
            verseStart: entry.key,
          ),
          segments: segmentsDtos.map((dto) => dto.toDomain()).toList(),
        );
      }).toList();

      return Right(verses);
    } catch (e) {
      print(e);
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<Verse>>> getChapter({
    required BibleId bibleId,
    required BibleRef ref,
  }) {
    // TODO: implement getChapter
    throw UnimplementedError();
  }

  // @override
  // Future<Either<Failure, List<VerseSegment>>> getChapter({
  //   required int bibleId,
  //   required BibleRef reference,
  // }) async {
  //   try {
  //     final List<VerseSegment> verses = await _contentDatasource.getChapter(
  //         bibleId, reference.book, reference.chapter);
  //     return Right(verses);
  //   } on NotFoundException catch (e) {
  //     return Left(
  //       ResourceNotFoundFailure(details: e.message),
  //     );
  //   } on LocalDataException catch (e) {
  //     return Left(
  //       DatabaseFailure(details: e.message),
  //     );
  //   } on AppException catch (e) {
  //     // Catch-all for future domain exceptions
  //     return Left(
  //       UnknownFailure(details: e.message),
  //     );
  //   } catch (e, st) {
  //     return Left(
  //       UnexpectedFailure(
  //         details: e.toString(),
  //         stackTrace: st,
  //       ),
  //     );
  //   }
  // }

  @override
  Future<Either<Failure, int>> getMaxVerse({
    required BibleBook book,
    required BibleRef ref,
  }) async {
    try {
      final max = await _contentDatasource.getVerseBoundaryOf(
        bookToken: book.usfm,
        chapter: ref.chapter,
      );

      return Right(max);
    } catch (e) {
      return Left(UnexpectedFailure(details: e.toString()));
    }
  }
}
