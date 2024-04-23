import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/exception.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/models/translation_model.dart';
import 'package:the_smyrna_bible_v2/core/utils/bible_reference_parser.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/scripture_finder/domain/entity/bible_reference.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/datasources/translations_datasource.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/models/translation_pool_model.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/models/translation_reader_model.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/repositories/reader_repository.dart';

class ReaderRepositoryImpl implements ReaderRepository {
  final TranslationPoolModel translationPool;
  final TranslationReaderModel reader;
  final TranslationsDataSource dataSource;

  ReaderRepositoryImpl({
    required this.translationPool,
    required this.reader,
    required this.dataSource,
  });

  void test(BibleReference reference) {
    // for each translation

    reader.translations.forEach(
      (t) {
        final book = t.bookNames.values
            .where(
              (element) => element.abbr == reference.book,
            )
            .singleOrNull;

        if (book != null) {
          book.chapters[reference.chapter].paragraphs.forEach((paragraph) {
            paragraph.verses.forEach((verse) {
              verse.words;
            });
          });
        }
      },
    );
  }

  @override
  Future<Either<Failure, TranslationModel>> getTranslation(String id) async {
    try {
      if (translationPool.pool[id] == null) {
        translationPool.pool[id] = await dataSource.getTranslation(id);
      }
      return Right(translationPool.pool[id]! as TranslationModel);
    } on NoLocalDataException {
      return const Left(NoLocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeTranslation(String id) async {
    try {
      reader.translations.removeWhere((t) => t.abbreviation == id);
      return const Right(null);

      // if all views are don't use a translation
      // removes it from pool
    } catch (e) {
      return const Left(NoLocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, BibleReference>> displayChapter(
      BibleReference ref) async {
    try {
      final book = reader.translations.first.bookNames.values
          .where(
            (bookData) =>
                bookData.abbr.toUpperCase().contains(ref.book) ||
                bookData.long.toUpperCase().contains(ref.book) ||
                bookData.short.toUpperCase().contains(ref.book),
          )
          .firstOrNull;

      if (book == null) throw InvalidInputException();
      if (ref.chapter > book.chapters.length || ref.chapter < 0) {
        throw InvalidInputException();
      }

      return Right(ref);
    } on InvalidInputException {
      return Left(InvalidInputFailure());
    }
  }
}
