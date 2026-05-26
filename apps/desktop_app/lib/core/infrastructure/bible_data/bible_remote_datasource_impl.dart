import 'package:open_scripture/core/engines/bible_compiler/domain/models/artifact.dart';
import 'package:open_scripture/core/infrastructure/bible_data/bible_datasource.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/shared/entities/bible_meta.dart';
import 'package:open_scripture/shared/entities/bible_ref.dart';
import 'package:open_scripture/shared/entities/book.dart';
import 'package:open_scripture/shared/entities/verse_segment.dart';

class BibleRemoteDatasourceImpl implements BibleDataSource {
  @override
  Future<BibleMeta> getBible(int bibleId) {
    // TODO: implement getBible
    throw UnimplementedError();
  }

  @override
  Future<List<Book>> getBooks(int bibleId) {
    // TODO: implement getBooks
    throw UnimplementedError();
  }

  @override
  Future<List<VerseSegment>> getChapter(
      int bibleId, String bookId, int chapter) {
    // TODO: implement getChapter
    throw UnimplementedError();
  }

  @override
  Future<List<VerseSegment>> getChapterWithSpans(
      int bibleId, String bookId, int chapter) {
    // TODO: implement getChapterWithSpans
    throw UnimplementedError();
  }

  @override
  Future<List<BibleMeta>> getInstalledBibles() {
    // TODO: implement getInstalledBibles
    throw UnimplementedError();
  }

  @override
  Future<int> getMaxChapter(int bookId) {
    // TODO: implement getMaxChapter
    throw UnimplementedError();
  }

  @override
  Future<int> getMaxVerseRange(int bookId, int chapter) {
    // TODO: implement getMaxVerseRange
    throw UnimplementedError();
  }

  @override
  Future<VerseSegment> getVerse(
      int bibleId, String book, int chapter, int verse) {
    // TODO: implement getVerse
    throw UnimplementedError();
  }

  @override
  Future<List<VerseSegment>> getVerseFromRange(
      int bibleId, String bookId, int chapter, int verse) {
    // TODO: implement getVerseFromRange
    throw UnimplementedError();
  }

  @override
  Future<List<VerseSegment>> getVersesSegments(
      int bibleId, List<BibleRef> refs) {
    // TODO: implement getVersesSegments
    throw UnimplementedError();
  }

  @override
  Stream<InstallProgress> installBible(Artifact artifact) {
    // TODO: implement installBible
    throw UnimplementedError();
  }

  @override
  Future<int> resolveBookNameToId(int bibleId, String extId) {
    // TODO: implement resolveBookNameToId
    throw UnimplementedError();
  }

  @override
  Future<List<BibleRef>> searchVerses(
      List<int> bibleIds, String matchingString) {
    // TODO: implement searchVerses
    throw UnimplementedError();
  }

  @override
  Future<void> uninstallBible(String bibleId) {
    // TODO: implement uninstallBible
    throw UnimplementedError();
  }

  @override
  Stream<List<BibleMeta>> watchInstalledBibles() {
    // TODO: implement watchInstalledBibles
    throw UnimplementedError();
  }
}
