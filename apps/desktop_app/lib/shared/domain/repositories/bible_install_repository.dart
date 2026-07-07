import '../../enums/bible_repository_type.dart';
import '../entities/bible_download_progress.dart';
import '../entities/bible_source.dart';
import '../services/bible_installer_strategy.dart';

abstract class BibleInstallRepository {
  void registerStrategy(
      BibleRepositoryType type, BibleInstallerStrategy strategy);
  Stream<InstallProgress> install(
      BibleSourceType source, BibleRepositoryType targetType);
  Future<void> uninstall(dynamic bibleId, BibleRepositoryType targetType);
}
