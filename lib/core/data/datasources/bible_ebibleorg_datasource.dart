// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import '../../../features/bible_installer_manager/domain/entities/bible_download_progress.dart';
import '../../constants/constants.dart' as constants;
import '../../domain/entities/bible_meta.dart';
import '../../error/exception.dart';

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
  Stream<InstallProgress> downloadBibleFileContent(String id);

  /// Gets a list of available to download translations
  ///
  /// Throws [ServerException] if it is unsuccessful
  Future<List<BibleMeta>> getListOfAllBibles();
}

class BibleRemoteDataSourceImpl implements BibleRemoteDataSource {
  BibleRemoteDataSourceImpl();

  final dio = Dio();

  @override
  Stream<InstallProgress> downloadBibleFileContent(
    String bibleId,
  ) {
    final controller = StreamController<InstallProgress>.broadcast();
    () async {
      try {
        final url = '${constants.contentSourceURL}/${bibleId}_usfx.zip';

        final appPath = await constants.getApplicationPath();
        final directory = Directory('$appPath/$bibleId');
        await directory.create(recursive: true);

        final filePath = '${directory.path}/$bibleId.zip';

        controller.add(const InstallProgress(
          received: 0,
          total: 0,
          stage: InstallStage.downloading,
        ));

        await dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            controller.add(
              InstallProgress(
                received: received,
                total: total < 0 ? 0 : total, // dio uses -1 when unknown
                stage: InstallStage.downloading,
              ),
            );
          },
        );

        controller.add(InstallProgress(
          received: 1,
          total: 1,
          stage: InstallStage.downloadingDone,
        ));

        await controller.close();
      } catch (e) {
        controller.add(InstallProgress(
          received: 0,
          total: 0,
          stage: InstallStage.failed,
        ));
        await controller.close();
      } finally {
        await controller.close();
      }
    }();

    return controller.stream;
  }

  @override
  Future<List<BibleMeta>> getListOfAllBibles() async {
    try {
      final response = await http.get(Uri.parse(constants.contentSourceURL));

      if (response.statusCode != 200) throw ServerException();

      final document = parser.parse(response.body);
      final rows = document.querySelectorAll('tr.redist');
      final List<BibleMeta> identificators = [];

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
                identificators.add(BibleMeta(
                  id: -1,
                  extId: id,
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
