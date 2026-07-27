import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../domain/entities/bible_book.dart';
import '../../../error/exception.dart';
import '../../models/verse_segment_dto.dart';
import 'bible_content_datasourcee.dart';

class RemoteBibleContentDatasourceImpl implements BibleContentDatasource {
  @override
  Future<int> getChapterBoundaryOf({required String bookToken}) {
    // TODO: implement getChapterBoundaryOf
    throw UnimplementedError();
  }

  @override
  Future<List<VerseSegmentDto>> getChapter(
    String bibleExtId,
    BibleBook book,
    int chapter,
  ) async {
    final query =
        '$kApiGetBibleV2Url/$bibleExtId/${book.osisIndex}/$chapter.json';

    final http.Response response;
    try {
      response = await http.get(Uri.parse(query));
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException {
      throw const NetworkException('Request timed out');
    }

    if (response.statusCode != 200) {
      throw ServerException(
        'Failed to fetch verses: $query',
        statusCode: response.statusCode,
      );
    }

    final List<VerseSegmentDto> segments;
    try {
      final rawJson = response.body;
      if (rawJson.isEmpty || rawJson == '[]') {
        throw NotFoundException(
            'No verses found for $bibleExtId ${book.osisIndex} $chapter');
      }

      final Map<String, dynamic> json = jsonDecode(rawJson);
      final List<dynamic>? parsedVerses = json['verses'];
      if (parsedVerses == null || parsedVerses.isEmpty) {
        throw NotFoundException(
            'No verses found for $bibleExtId ${book.osisIndex} $chapter');
      }

      segments = parsedVerses
          .map((verseData) => VerseSegmentDto.fromGetBibleApiV2(
                verseData: verseData,
                book: book,
                bibleExtId: bibleExtId,
              ))
          .toList();
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw ServerException('Malformed verse response: $e');
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
