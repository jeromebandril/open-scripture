import 'package:open_scripture/shared/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/shared/domain/entities/bible_source.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';

abstract class BibleInstallRepository {
  Stream<InstallProgress> install(
      BibleSourceType source, BibleRepositoryType targetType);
  Future<void> uninstall(int bibleId, BibleRepositoryType targetType);
}
