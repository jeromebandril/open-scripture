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
  /// Downloads a bible archive from the remote catalog and persists it
  /// to a deterministic location in the local file system.
  ///
  /// The archive is not parsed or installed by this method. Its sole
  /// responsibility is network transfer and progress reporting.
  ///
  /// The returned [Stream] emits [InstallProgress] updates describing
  /// the download lifecycle (started, in progress, completed, failed).
  ///
  /// Errors are surfaced through the stream error channel as
  /// [DownloadException] (or other [AppException] subtypes).
  ///
  /// The stream completes once the download finishes or fails.
  Stream<InstallProgress> downloadBibleFileContent(String id);

  /// Retrieves the remote catalog of available bible translations.
  ///
  /// This method performs a network request to the content source and
  /// parses the response into a list of [BibleMeta] descriptors.
  ///
  /// No local persistence or installation is performed.
  ///
  /// Throws an [AppException] subtype (e.g. [ServerException],
  /// [ParsingException]) if the request fails or the response
  /// cannot be interpreted.
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
          message: 'Starting download...',
        ));

        await dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            if (controller.isClosed) return;

            controller.add(
              InstallProgress(
                received: received,
                total: total < 0 ? 0 : total,
                stage: InstallStage.downloading,
                message: 'Downloading...',
              ),
            );
          },
        );

        controller.add(const InstallProgress(
          received: 1,
          total: 1,
          stage: InstallStage.downloadingDone,
          message: 'Download completed',
        ));
      } on DioException catch (e, st) {
        // Emit failed progress for UI:
        if (!controller.isClosed) {
          controller.add(InstallProgress(
            received: 0,
            total: 0,
            stage: InstallStage.failed,
            message: 'Download failed',
          ));
        }

        // Also emit a typed error so repository/bloc can classify it:
        if (!controller.isClosed) {
          controller.addError(
            DownloadException(
              'Failed to download $bibleId: ${e.message ?? e.type.name}',
              cause: e,
              stackTrace: st,
            ),
            st,
          );
        }
      } catch (e, st) {
        if (!controller.isClosed) {
          controller.add(const InstallProgress(
            received: 0,
            total: 0,
            stage: InstallStage.failed,
            message: 'Download failed (unexpected)',
          ));
        }
        if (!controller.isClosed) {
          controller.addError(
            DownloadException(
              'Unexpected error while downloading $bibleId',
              cause: e,
              stackTrace: st,
            ),
            st,
          );
        }
      } finally {
        if (!controller.isClosed) {
          await controller.close();
        }
      }
    }();

    return controller.stream;
  }

  @override
  Future<List<BibleMeta>> getListOfAllBibles() async {
    try {
      final response = await http.get(Uri.parse(constants.contentSourceURL));

      if (response.statusCode != 200) {
        throw ServerException('HTTP ${response.statusCode}');
      }

      final document = parser.parse(response.body);
      final rows = document.querySelectorAll('tr.redist');
      // final List<BibleMeta> identificators = [];

      if (rows.isEmpty) {
        throw ParseException('No rows found: tr.redist');
      }

      final metas = <BibleMeta>[];

      for (final row in rows) {
        final lastTd = row.querySelector('td:last-child');
        final thirdTd = row.querySelector('td:nth-child(2)');

        final link = lastTd?.querySelector('a');
        final language = thirdTd?.querySelector('a')?.innerHtml;
        final name = link?.innerHtml;

        final href = link?.attributes['href'];
        final id = href == null ? null : Uri.parse(href).queryParameters['id'];

        if (id == null || name == null || language == null) {
          // Skip malformed rows rather than crashing the whole call.
          continue;
        }

        metas.add(BibleMeta(
          id: -1,
          extId: id,
          bibleName: name,
          langEngName: language,
          abbreviation: id,
        ));
      }

      if (metas.isEmpty) {
        throw ParseException('No valid BibleMeta parsed from page');
      }

      return metas;

      // for (final row in rows) {
      //   final lastTd = row.querySelector('td:last-child');
      //   final thirdTd = row.querySelector('td:nth-child(2)');

      //   final link = lastTd!.querySelector('a');
      //   final language = thirdTd!.querySelector('a')!.innerHtml;
      //   final name = link?.innerHtml;

      //   if (link != null) {
      //     final href = link.attributes['href'];
      //     if (href != null) {
      //       final id = Uri.parse(href).queryParameters['id'];
      //       if (id != null) {
      //         identificators.add(BibleMeta(
      //           id: -1,
      //           extId: id,
      //           bibleName: name!,
      //           langEngName: language,
      //           abbreviation: id,
      //         ));
      //       }
      //     }
      //   }
      // }
      // return identificators;
    } on http.ClientException catch (e) {
      throw NetworkException(e.toString());
    } on FormatException catch (e) {
      throw ParseException(e.toString());
    }
  }
}
