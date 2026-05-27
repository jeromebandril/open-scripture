import 'package:fpdart/fpdart.dart';

import '../../../../shared/entities/bible_meta.dart';
import '../../../../shared/error/failure.dart';
import '../entities/bible_download_progress.dart';

abstract class BibleManagerRepository {
  Stream<InstallProgress> downloadAndInstallBible(String bibleId);
  Future<Either<Failure, List<BibleMeta>>> getDownloadCatalog();
  Future<Either<Failure, void>> uninstallBible(String id);
}
