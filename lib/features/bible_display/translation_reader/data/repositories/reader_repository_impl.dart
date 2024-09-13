import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/exception.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/data/models/translation_model.dart';
import 'package:the_smyrna_bible_v2/core/utils/bible_reference_parser.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/data/datasources/translations_datasource.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/entities/page.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/repositories/reader_repository.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/translation.dart';

import '../../../../../core/domain/entities/bible_reference.dart';

class ReaderRepositoryImpl implements ReaderRepository {
  Map<String, TranslationModel> translationPool = {};
  final TranslationsDataSource localDataSource;

  ReaderRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, TranslationModel>> openTranslation(String id) async {
    try {
      if (translationPool[id] == null) {
        print("> BReader: load for the first time $id");
        translationPool[id] = await localDataSource.getTranslation(id);
      }
      print("> BReader: translation loaded successfully");
      return Right(translationPool[id]!);
    } on NoLocalDataException {
      return const Left(NoLocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeTranslation(String id) async {
    try {
      // reader.translations.removeWhere((t) => t.abbreviation == id);
      return const Right(null);

      // if all views are don't use a translation
      // removes it from pool
    } catch (e) {
      return const Left(NoLocalDataFailure());
    }
  }
  //
  // OLD IMPLEMENTATION
  //
  // @override
  // Future<Either<Failure, List<BibleReference>>> getChapter(
  //     BibleReference ref) async {
  //   try {
  //     //
  //     // Use temporarly eng-kjv for test which is the most common
  //     // TODO: replace in the future with a variable or parameter
  //     //
  //     // Find the given reference in the given book
  //     //
  //     final book = translationPool['eng-kjv']!
  //         .bookNames
  //         .values
  //         .where(
  //           (bookData) =>
  //               bookData.abbr.toUpperCase().contains(ref.book) ||
  //               bookData.long.toUpperCase().contains(ref.book) ||
  //               bookData.short.toUpperCase().contains(ref.book),
  //         )
  //         .firstOrNull;
  //     //
  //     // Handle exceptions
  //     //
  //     if (book == null ||
  //         ref.chapter > book.chapters.length ||
  //         ref.chapter < 0) {
  //       throw InvalidInputException();
  //     }
  //     //
  //     // Make a list of all References of the chapter
  //     // in which the given reference is
  //     // (in this case it corrispond to each verse of the same chapter)
  //     //
  //     List<BibleReference> temp = [];
  //     for (int i = 0;
  //         // iterate trough the verses
  //         // (which are grouped by paragraphs in this case)
  //         i <
  //             translationPool['eng-kjv']!
  //                 .bookNames[book.abbr.toUpperCase()]!
  //                 .chapters[ref.chapter]
  //                 .paragraphs
  //                 .map((paragraph) => paragraph.verses.length)
  //                 .fold(0, (prev, count) => prev + count);
  //         i++) {
  //       temp.add(
  //           BibleReference(book: ref.book, chapter: ref.chapter, verse: i));
  //     }

  //     print("> Reader: result is ${temp.length} verses");
  //     return Right(temp);
  //   } on InvalidInputException {
  //     return Left(InvalidInputFailure());
  //   }
  // }

  /// returns a Chapter in the form of PageContent, meaning it's a collection
  /// of verses of the same context
  @override
  Future<Either<Failure, PageContent>> getChapter(BibleRef ref) async {
    try {
      //
      // Use temporarly hardcoded eng-kjv for test which is the most common version
      // TODO: replace in the future with a variable or parameter
      //
      // Find the given reference in the current book
      //
      final book = translationPool['eng-kjv']!
          .bookNames
          .values
          .where(
            (bookData) =>
                bookData.abbr.toUpperCase().contains(ref.book.toUpperCase()) ||
                bookData.long.toUpperCase().contains(ref.book.toUpperCase()) ||
                bookData.short.toUpperCase().contains(ref.book.toUpperCase()),
          )
          .firstOrNull;
      //
      // Handle exceptions
      //
      if (book == null ||
          ref.chapter > book.chapters.length ||
          ref.chapter < 0) {
        throw InvalidInputException();
      }
      if (book.chapters.isEmpty ||
          ref.chapter >= book.chapters.length && ref.chapter < 0) {
        throw InvalidInputException();
      }

      final content = PageContent(
        isHeterogeneous: false,
        booknameAbbreviation: book.abbr,
        booknameFull: book.long,
        chapterNumber: ref.chapter + 1,
        content: book.chapters[ref.chapter].paragraphs,
      );

      return Right(content);
    } on InvalidInputException {
      return Left(InvalidInputFailure());
    }
  }

  @override
  Future<Either<Failure, Translation>> getTranslation(String id) {
    if (translationPool[id] != null) {
      return Future.value(Right(translationPool[id]!));
    } else {
      return Future.value(const Left(NoLocalDataFailure()));
    }
  }
}
