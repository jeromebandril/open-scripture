import '../../domain/entities/bible_download_progress.dart';
import '../../domain/entities/bible_source.dart';
import '../../domain/repositories/bible_install_repository.dart';
import '../../domain/services/bible_installer_strategy.dart';
import '../../enums/bible_repository_type.dart';

class BibleInstallRepositoryImpl implements BibleInstallRepository {
  final Map<BibleRepositoryType, BibleInstallerStrategy> _strategies;

  BibleInstallRepositoryImpl(this._strategies);

  @override
  Stream<InstallProgress> install(
      BibleSourceType source, BibleRepositoryType targetType) {
    final strategy = _strategies[targetType];
    if (strategy == null) {
      throw ArgumentError('No installation strategy found for $targetType');
    }
    return strategy.install(source);
  }

  @override
  Future<void> uninstall(
      dynamic bibleId, BibleRepositoryType targetType) async {
    final strategy = _strategies[targetType];
    if (strategy == null) return;
    await strategy.uninstall(bibleId);
  }
}
