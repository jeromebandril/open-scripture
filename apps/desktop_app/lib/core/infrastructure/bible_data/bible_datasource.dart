import 'package:open_scripture/core/engines/bible_compiler/domain/models/artifact.dart';
import 'package:open_scripture/shared/entities/book.dart';
import 'package:open_scripture/shared/entities/bible_ref.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/entities/bible_download_progress.dart';

import '../../../shared/entities/bible_meta.dart';
import '../../../shared/error/exception.dart';
import '../../../shared/entities/verse_segment.dart';

abstract class BibleDataSource {
  /// Installs a previously downloaded bible archive into the local store.
  ///
  /// This method assumes the archive has already been downloaded to the
  /// deterministic location used by the remote data source (based on [bibleId]).
  ///
  /// Installation typically includes:
  /// - reading the downloaded ZIP file from disk
  /// - extracting USFX + metadata
  /// - parsing XML into models
  /// - writing content to SQLite (usually in a transaction)
  /// - cleanup of temporary artifacts
  ///
  /// Returns a [Stream] of [InstallProgress] describing the installation
  /// lifecycle (installing, writing to DB, done, failed).
  ///
  /// Errors are surfaced through the stream error channel as an [AppException]
  /// subtype (e.g. InstallFileMissingException, InstallParseException,
  /// InstallDatabaseException).
  Stream<InstallProgress> installBible(Artifact artifact);

  /// Uninstalls an installed bible from the local store.
  ///
  /// This should remove the bible metadata and all related content rows.
  ///
  /// Throws an [AppException] subtype if the operation fails.
  /// Common cases:
  /// - [UninstallNotFoundException] if the bible is not installed
  /// - [UninstallationException] for unexpected database failures
  Future<void> uninstallBible(String bibleId);

  /// Returns the list of bibles currently installed in the local store.
  ///
  /// This is a one-shot read (no live updates).
  ///
  /// Throws an [AppException] subtype (e.g. [LocalDataException]) if the
  /// query fails.
  Future<List<BibleMeta>> getInstalledBibles();

  /// Retrieves bible metadata for a specific installed bible by its local id.
  ///
  /// Throws:
  /// - [NotFoundException] if the bible id does not exist
  /// - [LocalDataException] for database/query failures
  Future<BibleMeta> getBible(int bibleId);

  /// Watches the list of installed bibles and emits updates whenever the
  /// underlying local store changes.
  ///
  /// Errors are surfaced via the stream error channel as an [AppException]
  /// subtype (typically [LocalDataException]).
  Stream<List<BibleMeta>> watchInstalledBibles();

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
