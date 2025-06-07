import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/entities/e_bible.dart';
import '../../../../core/error/failure.dart';
import '../entities/bible_download_progress.dart';

abstract class BibleManagerRepository {
  Future<Either<Failure, Stream<DownloadProgess>>> downloadTranslation(
      String bibleId);

  Future<Either<Failure, void>> installTranslation(String bibleid);

  Future<dynamic> uninstallTranslation(String bibleId);

  Future<Either<Failure, List<EBible>>> getAllInstalledBibles();

  Future<Either<Failure, List<EBible>>> getAllDownloadableBibles();
}
