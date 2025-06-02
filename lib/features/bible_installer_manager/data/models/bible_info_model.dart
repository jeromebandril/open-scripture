import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/translation_info.dart';

class BibleInfoModel extends TranslationInfo {
  const BibleInfoModel({
    required super.id,
    required super.name,
    required super.language,
    super.downloadStatus = DownloadStatus.notDownloaded,
  });

  Future<bool> checkIfAlreadyInstalled() async {
    final dir = (await getApplicationSupportDirectory()).path;
    final dirDestination = Directory('$dir/$id');
    return await dirDestination.exists();
  }

  toDomain() {
    return TranslationInfo(id: id, name: name, language: language);
  }

  // TranslationInfoModel copyWith({
  //   String Function()? id,
  //   String Function()? name,
  //   String Function()? language,
  //   int Function()? downloadedBytes,
  //   int Function()? totalBytes,
  //   DownloadStatus Function()? downloadStatus,
  // }) {
  //   return TranslationInfoModel(
  //     id: id != null ? id() : this.id,
  //     name: name != null ? name() : this.name,
  //     language: language != null ? language() : this.language,
  //     downloadStatus:
  //         downloadStatus != null ? downloadStatus() : this.downloadStatus,
  //   );
  // }
}
