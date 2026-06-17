import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_scripture/shared/constants.dart';
import 'package:open_scripture/shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import 'package:open_scripture/shared/data/models/verse_segment_dto.dart';
import 'package:open_scripture/shared/domain/entities/bible_book.dart';

class RemoteBibleContentDatasourceImpl implements BibleContentDatasource {
  @override
  Future<int> getChapterBoundaryOf({required String bookToken}) {
    // TODO: implement getChapterBoundaryOf
    throw UnimplementedError();
  }

  @override
  Future<List<VerseSegmentDto>> getChapterWithSpans(
    String bibleExtId,
    BibleBook book,
    int chapter,
  ) async {
    final query =
        '$kApiGetBibleV2Url/$bibleExtId/${book.osisIndex}/$chapter.json';
    final response = await http.get(Uri.parse(query));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch verses: $query');
    }

    final rawJson = response.body;
    if (rawJson.isEmpty || rawJson == "[]") {
      return Future.value([]);
    }

    final Map<String, dynamic> json = jsonDecode(rawJson);
    final List<dynamic>? parsedVerses = json['verses'];
    if (parsedVerses == null || parsedVerses.isEmpty) return [];

    final List<VerseSegmentDto> segments = [];

    for (final verseData in parsedVerses) {
      segments.add(VerseSegmentDto.fromGetBibleApiV2(
        verseData: verseData,
        book: book,
        bibleExtId: bibleExtId,
      ));
    }

    return segments;
  }

  @override
  Future<int> getVerseBoundaryOf(
      {required String bookToken, required int chapter}) {
    // TODO: implement getVerseBoundaryOf
    throw UnimplementedError();
  }

  @override
  Future<List<String>> searchVerses(List<int> bibleIds, String matchingString) {
    // TODO: implement searchVerses
    throw UnimplementedError();
  }
}
