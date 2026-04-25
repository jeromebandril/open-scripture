import 'package:fpdart/fpdart.dart';

import '../../../../shared/entities/bible_meta.dart';
import '../../../../shared/error/failure.dart';
import '../entities/bible_download_progress.dart';

abstract class BibleManagerRepository {
  Stream<InstallProgress> downloadBible(String bibleId);

  Stream<InstallProgress> installBible(String bibleId);

  Stream<InstallProgress> downloadAndInstallBible(String bibleId);

  Future<Either<Failure, void>> uninstallTranslation(String bibleId);

  Future<Either<Failure, List<BibleMeta>>> getAllInstalledBibles();

  Stream<List<BibleMeta>> watchAllInstalledBibles();

  Future<Either<Failure, List<BibleMeta>>> getAllDownloadableBibles();
}
