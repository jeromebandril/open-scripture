// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import '../../../features/bible_installer_manager/domain/entities/bible_download_progress.dart';
import '../../constants/constants.dart' as constants;
import '../../error/exception.dart';
import '../models/bible_model.dart';

abstract class BibleRemoteDataSource {
  /// Get bytes of a general bible file format
  /// And writes it temporarly in local file system,
  /// ready to be installed (converted to the preferred
  /// and expected file format).
  ///
  /// Returns a Stream to listen to the download
  /// progress.
  ///
  /// Throws [ServerException] if it is unsuccessful
  Stream<DownloadProgess> downloadBibleFileContent(String id);

  /// Gets a list of available to download translations
  ///
  /// Throws [ServerException] if it is unsuccessful
  Future<List<BibleModel>> getListOfAllBibles();
}

class BibleRemoteDataSourceImpl implements BibleRemoteDataSource {
  BibleRemoteDataSourceImpl();

  final dio = Dio();

  @override
  Stream<DownloadProgess> downloadBibleFileContent(
    String bibleId,
  ) async* {
    try {
      final url =
          Uri.parse('${constants.contentSourceURL}/${bibleId}_usfx.zip');
      final appPath = await constants.getApplicationPath();
      final directory = Directory('$appPath/$bibleId');
      final filePath = '${directory.path}/temp.txt';

      final controller = StreamController<DownloadProgess>();

      await dio.downloadUri(
        url,
        filePath,
        options: Options(responseType: ResponseType.stream),
        onReceiveProgress: (received, total) {
          controller.add(DownloadProgess(
            received: received,
            total: total,
            downloadStatus: DownloadStatus.inProgress,
          ));
        },
      );

      yield* controller.stream;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<BibleModel>> getListOfAllBibles() async {
    try {
      final response = await http.get(Uri.parse(constants.contentSourceURL));

      if (response.statusCode != 200) throw ServerException();

      final document = parser.parse(response.body);
      final rows = document.querySelectorAll('tr.redist');
      final List<BibleModel> identificators = [];

      if (rows.isEmpty) {
        throw ServerException();
      } else {
        for (var row in rows) {
          final lastTd = row.querySelector('td:last-child');
          final thirdTd = row.querySelector('td:nth-child(2)');

          final link = lastTd!.querySelector('a');
          final language = thirdTd!.querySelector('a')!.innerHtml;
          final name = link?.innerHtml;

          if (link != null) {
            final href = link.attributes['href'];
            if (href != null) {
              final id = Uri.parse(href).queryParameters['id'];
              if (id != null) {
                identificators.add(BibleModel(
                  id: 1,
                  bibleName: name!,
                  langEngName: language,
                  abbreviation: id,
                ));
              }
            }
          }
        }
      }
      return identificators;
    } catch (e) {
      throw ServerException();
    }
  }
}
