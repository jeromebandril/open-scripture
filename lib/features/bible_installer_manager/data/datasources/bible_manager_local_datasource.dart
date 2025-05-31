import 'package:the_smyrna_bible_v2/core/data/models/bible_model.dart';

import '../../../../core/database/database.dart';
import '../../../../core/error/exception.dart';

abstract class BibleManagerLocalDataSource {
  /// Try to install a translation locally.
  /// It receives a path to the temp_file were the content of
  /// type [List<int>] has been downloaded,
  /// and convert it into expected files/structure.
  ///
  /// Throws a [InstallationException] if it fails
  Future<void> installTranslation(String path);

  /// Uninstall a local translation (removes files).
  ///
  /// Throws a [InstallationException] if it fails
  Future<void> uninstallTranslation(String path);

  /// Get a list of installed translations info
  /// as [TranslationInfoModel] object
  ///
  /// Throws a [NoLocalDataException] if it fails
  Future<List<BibleModel>> getInstalledTransationInfos();
}

class BibleManagerLocalDataSourceImpl implements BibleManagerLocalDataSource {
  final AppDb db;

  BibleManagerLocalDataSourceImpl({required this.db});

  /*
  * New Implementation using SQL Lite as main storage system
  */
  @override
  Future<List<BibleModel>> getInstalledTransationInfos() async {
    List<GetBiblesResult> result = await db.getBibles().get();
    const List<BibleModel> bibles = [];

    for (var item in result) {
      bibles.add(BibleModel.fromDatabase(item));
    }

    return bibles;
  }

  @override
  Future<void> installTranslation(String path) {
    // TODO: implement installTranslation
    throw UnimplementedError();
  }

  @override
  Future<void> uninstallTranslation(String path) {
    // TODO: implement uninstallTranslation
    throw UnimplementedError();
  }

  // ************************************************************************
  // Old implementation with direct read/write from the filesystem and managing
  // manually the files
  //************************************************************************* */
  /*
  @override
  Future<void> installTranslation(String id) async {
    try {
      final path = await ApplicationConstants.getApplicationPath();
      File rawFile = File("$path/$id/temp.txt");
      final bytes = await rawFile.readAsBytes();

      // convert raw file into usfx.xml file format
      // should find both metadata.xml and translation_usfx.xml
      File goodFile = File('$path/$id/${id}_usfx.xml');
      File metadataFile = File('$path/$id/${id}metadata.xml');
      final Archive archive = ZipDecoder().decodeBytes(bytes);

      for (final ArchiveFile file in archive) {
        if (file.name == '${id}_usfx.xml') {
          goodFile.writeAsBytesSync(file.content);
        }
        if (file.name == '${id}metadata.xml') {
          metadataFile.writeAsBytesSync(file.content);
        }
      }

      // delete the temp file
      rawFile.deleteSync();
    } catch (e) {
      throw InstallationException();
    }
  }

  @override
  Future<void> uninstallTranslation(String id) async {
    try {
      final path = await ApplicationConstants.getApplicationPath();
      Directory directory = Directory("$path/$id");
      directory.delete(recursive: true);
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<TranslationInfoModel>> getInstalledTransationInfos() async {
    try {
      final appDir = Directory(
        await ApplicationConstants.getApplicationPath(),
      );
      final subDirs = await appDir.list().toList();
      final List<TranslationInfoModel> infos = [];

      for (var sd in subDirs) {
        String ok = sd.path;
        infos.add(
          TranslationInfoModel(
            id: ok,
            name: ok,
            language: ok,
          ),
        );
      }

      return infos;
    } catch (e) {
      throw NoLocalDataException();
    }
  }
  */
}
