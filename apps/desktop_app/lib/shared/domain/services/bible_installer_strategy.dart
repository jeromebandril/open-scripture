import 'package:open_scripture/shared/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/shared/domain/entities/bible_source.dart';

abstract class BibleInstallerStrategy {
  /// Executes the installation process and yields progress updates
  Stream<InstallProgress> install(BibleSourceType source);

  Future<void> uninstall(dynamic bibleId);
}
