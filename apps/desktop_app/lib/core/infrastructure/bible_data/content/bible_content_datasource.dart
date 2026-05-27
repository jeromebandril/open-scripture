import 'package:open_scripture/shared/entities/book.dart';
import 'package:open_scripture/shared/entities/bible_ref.dart';

import '../../../../shared/error/exception.dart';
import '../../../../shared/entities/verse_segment.dart';

abstract class BibleContentDatasource {
  /// Loads a single verse (as one or more segments depending on your model).
  ///
  /// Throws:
  /// - [NotFoundException] if the verse does not exist
  /// - [LocalDataException] for database/query failures
  Future<VerseSegment> getVerse(
      int bibleId, String book, int chapter, int verse);

  /// Loads a list of verses within a range.
  ///
  /// Throws:
  /// - [NotFoundException] if the range yields no verses
  /// - [LocalDataException] for database/query failures
  Future<List<VerseSegment>> getVerseFromRange(
      int bibleId, String bookId, int chapter, int verse);

  /// Loads all verse segments for a chapter (text only, no spans
  /// e.g. no formatting)
  ///
  /// Throws:
  /// - [NotFoundException] if the chapter has no content
  /// - [LocalDataException] for database/query failures
  Future<List<VerseSegment>> getChapter(
      int bibleId, String bookId, int chapter);

  /// Loads all verse segments for a chapter, including formatting spans.
  ///
  /// Throws:
  /// - [NotFoundException] if the chapter has no content
  /// - [LocalDataException] for database/query failures
  Future<List<VerseSegment>> getChapterWithSpans(
      int bibleId, String bookId, int chapter);

  /// Loads the list of books available for a given installed bible.
  ///
  ///
  /// Throws:
  /// - [NotFoundException] if the bible has no books / is not installed
  /// - [LocalDataException] for database/query failures
  Future<List<Book>> getBooks(int bibleId);

  /// Search a string within the given bibles
  /// and returns a List of bible references
  ///
  /// Throws:
  /// - [NotFoundException] if the range yields no verses
  /// - [LocalDataException] for database/query failures
  Future<List<BibleRef>> searchVerses(
      List<int> bibleIds, String matchingString);

  /// Get verse segments from a List of bible references
  ///
  /// Throws:
  /// - [NotFoundException] if the range yields no verses
  /// - [LocalDataException] for database/query failures
  Future<List<VerseSegment>> getVersesSegments(
      int bibleId, List<BibleRef> refs);

  Future<int> getMaxChapter(int bookId);
  Future<int> getMaxVerseRange(int bookId, int chapter);
  Future<int> resolveBookNameToId(int bibleId, String extId);
}
