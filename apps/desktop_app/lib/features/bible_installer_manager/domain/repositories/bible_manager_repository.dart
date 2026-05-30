import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/error/failure.dart';

abstract class BibleManagerRepository {
  Stream<InstallProgress> downloadAndInstallBible(String bibleId);
  Future<Either<Failure, List<BibleTranslation>>> getDownloadCatalog();
  Future<Either<Failure, void>> uninstallBible(String id);
}
