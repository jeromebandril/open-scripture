import 'package:open_scripture/shared/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/shared/domain/entities/bible_source.dart';

abstract class BibleInstallRepository {
  Stream<InstallProgress> install(BibleSourceType source);
  Future<void> uninstall(int bibleId);
}
