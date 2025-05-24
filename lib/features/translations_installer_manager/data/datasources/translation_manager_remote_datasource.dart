// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:the_smyrna_bible_v2/core/constants/constants.dart' as Constants;
import 'package:the_smyrna_bible_v2/core/error/exception.dart';

import '../models/translation_info_model.dart';

abstract class TranslationManagerRemoteDataSource {
  /// Get bytes of a general bible file format
  /// And writes it temporarly in local file system,
  /// ready to be installed (converted to the preferred
  /// and expected file format).
  ///
  /// Returns a Stream to listen to the download
  /// progress.
  ///
  /// Throws [ServerException] if it is unsuccessful
  Stream<List<int>> downloadTranslationFiles(String id);

  /// Gets a list of available to download translations
  /// from eBible.org endpoint
  ///
  /// Throws [ServerException] if it is unsuccessful
  Future<List<TranslationInfoModel>> getListOfAllTranslations();
}

class TranslationManagerRemoteDataSourceImpl
    implements TranslationManagerRemoteDataSource {
  TranslationManagerRemoteDataSourceImpl();

  final dio = Dio();

  @override
  Stream<List<int>> downloadTranslationFiles(
    String id,
  ) async* {
    try {
      final url = Uri.parse('${Constants.contentSourceURL}/${id}_usfx.zip');
      final appPath = await Constants.getApplicationPath();
      final translationDir = Directory('$appPath/$id');
      final downloadController = StreamController<List<int>>();
      dio.downloadUri(
        url,
        '${translationDir.path}/temp.txt',
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          downloadController.add([received, total]);
        },
      ).then((value) => downloadController.close());

      yield* downloadController.stream;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<TranslationInfoModel>> getListOfAllTranslations() async {
    try {
      final response = await http.get(Uri.parse(Constants.contentSourceURL));

      if (response.statusCode != 200) throw ServerException();

      final document = parser.parse(response.body);
      final rows = document.querySelectorAll('tr.redist');
      final List<TranslationInfoModel> identificators = [];

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
                identificators.add(TranslationInfoModel(
                  id: id,
                  name: name!,
                  language: language,
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
