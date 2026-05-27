import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_scripture/core/di/injection_container.dart' as di;
import 'package:open_scripture/core/infrastructure/bible_data/content/bible_content_datasource.dart';
import 'package:open_scripture/core/infrastructure/book_resolver/book_resolver.dart';
import 'package:open_scripture/features/my_library/data/datasources/my_library_datasource.dart';
import 'package:open_scripture/shared/entities/bible_ref.dart';
import 'package:open_scripture/shared/entities/book.dart';
import 'package:open_scripture/shared/entities/verse_segment.dart';

class BibleContentDatasourceRemoteImpl implements BibleContentDatasource {
  static const _base = 'https://api.getbible.net/v2';

  final MyLibraryDatasource libraryDatasource = di.sl<MyLibraryDatasource>();
  final bookResolver = di.sl<BibleRefResolver>();

  BibleContentDatasourceRemoteImpl();

  // -------------------------------------------------------------------------
  // SUPPORTED
  // -------------------------------------------------------------------------

  // @override
  // Future<List<Book>> getBooks(int bibleId) async {
  //   final bible = await getBible(bibleId);
  //   final response = await http.get(
  //     Uri.parse('$_base/${bible.abbreviation}/books.json'),
  //   );
  //   if (response.statusCode != 200) throw Exception('Failed to load books');

  //   final Map<String, dynamic> json = jsonDecode(response.body);
  //   return json.entries.map((e) {
  //     final data = e.value as Map<String, dynamic>;
  //     return Book(
  //       id: int.parse(e.key),
  //       name: data['name'] as String,
  //       bibleId: bibleId,
  //     );
  //   }).toList();
  // }

  // @override
  // Future<List<Book>> getBooks(int bibleId) {
  //   // TODO: implement getBooks
  //   throw UnimplementedError();
  // }
  Future<String> _abbreviationFor(int bibleId) async {
    final bible = await libraryDatasource.getBible(bibleId);
    return bible.abbreviation;
  }

  @override
  Future<List<VerseSegment>> getChapter(
      int bibleId, String bookId, int chapter) async {
    final abbr = await _abbreviationFor(bibleId);
    final response = await http.get(
      Uri.parse('$_base/$abbr/${2}/$chapter.json'),
    );
    if (response.statusCode != 200) throw Exception('Failed to load chapter');

    final Map<String, dynamic> json = jsonDecode(response.body);

    final verses = json['verses'] as List<dynamic>;

    return verses.map((v) {
      final data = v as Map<String, dynamic>;
      return VerseSegment(
        ref: BibleRef(
          bookUsfxId: bookId,
          chapter: data['chapter'],
          verseStart: data['verse'],
        ),
        segmentIndex: 0,
        paragraphStart: false,
        textContent: data['text'],
        subtitle: '',
        spans: [],
      );
    }).toList();
  }

  @override
  Future<List<VerseSegment>> getChapterWithSpans(
      int bibleId, String bookId, int chapter) async {
    // APIs don't have any additional metadata or formatting - fall back to plain chapter
    return getChapter(bibleId, bookId, chapter);
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
  Future<List<Book>> getBooks(int bibleId) {
    // TODO: implement getBooks
    throw UnimplementedError();
  }

  // @override
  // Future<VerseSegment> getVerse(
  //     int bibleId, String book, int chapter, int verse) async {
  //   final verses = await getChapter(bibleId, book, chapter);
  //   return verses.firstWhere((v) => v.verse == verse);
  // }

  // @override
  // Future<List<VerseSegment>> getVerseFromRange(
  //     int bibleId, String bookId, int chapter, int verse) async {
  //   final verses = await getChapter(bibleId, bookId, chapter);
  //   return verses.where((v) => v.verse >= verse).toList();
  // }

  // @override
  // Future<List<VerseSegment>> getVersesSegments(
  //     int bibleId, List<BibleRef> refs) async {
  //   // Group refs by book+chapter to minimize API calls
  //   final Map<String, List<BibleRef>> grouped = {};
  //   for (final ref in refs) {
  //     final key = '${ref.bookId}/${ref.chapter}';
  //     grouped.putIfAbsent(key, () => []).add(ref);
  //   }

  //   final List<VerseSegment> results = [];
  //   for (final entry in grouped.entries) {
  //     final parts = entry.key.split('/');
  //     final chapterVerses = await getChapter(
  //       bibleId,
  //       parts[0],
  //       int.parse(parts[1]),
  //     );
  //     for (final ref in entry.value) {
  //       results.addAll(chapterVerses.where((v) => v.verse == ref.verse));
  //     }
  //   }
  //   return results;
  // }

  // @override
  // Future<int> getMaxChapter(int bookId) async {
  //   // getbible.net has no direct endpoint for this — not supported on web
  //   throw UnsupportedError('getMaxChapter not supported on web');
  // }

  // @override
  // Future<int> getMaxVerseRange(int bookId, int chapter) async {
  //   throw UnsupportedError('getMaxVerseRange not supported on web');
  // }

  // @override
  // Future<int> resolveBookNameToId(int bibleId, String extId) async {
  //   throw UnsupportedError('resolveBookNameToId not supported on web');
  // }

  // @override
  // Future<List<BibleRef>> searchVerses(
  //     List<int> bibleIds, String matchingString) async {
  //   throw UnsupportedError('searchVerses not supported on web');
  // }

  // // -------------------------------------------------------------------------
  // // DESKTOP-ONLY — never called on web (features guarded at DI level)
  // // -------------------------------------------------------------------------

  // @override
  // Stream<InstallProgress> installBible(Artifact artifact) =>
  //     throw UnsupportedError('installBible is desktop-only');

  // @override
  // Future<void> uninstallBible(String bibleId) =>
  //     throw UnsupportedError('uninstallBible is desktop-only');
}
