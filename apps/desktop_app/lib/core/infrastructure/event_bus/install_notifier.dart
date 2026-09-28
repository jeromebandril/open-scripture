import '../../../shared/enums/bible_repository_type.dart';
import 'event_bus.dart';

/// Doesn't stream any data. Its purpose is to send signal whenever
/// a bible gets installed, so it can sync with [MylibraryCubit]
class InstallNotifier extends EventBus<BibleRepositoryType?> {
  void refreshInstalledList({BibleRepositoryType? repoType}) {
    emit(repoType);
  }
}
