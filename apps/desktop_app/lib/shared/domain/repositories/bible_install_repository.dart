import '../../enums/bible_repository_type.dart';
import '../entities/bible_download_progress.dart';
import '../entities/bible_source.dart';

abstract class BibleInstallRepository {
  Stream<InstallProgress> install(
      BibleSourceType source, BibleRepositoryType targetType);
  Future<void> uninstall(dynamic bibleId, BibleRepositoryType targetType);
}
