import 'dart:async';

import '../../../shared/enums/bible_repository_type.dart';

/// Doesn't stream any data. Its purpose is to send signal whenever
/// a bible gets installed, so it can sync with [MylibraryCubit]
class InstallNotifier {
  final _c = StreamController<BibleRepositoryType?>.broadcast();
  Stream<BibleRepositoryType?> get stream => _c.stream;

  void refreshInstalledList({BibleRepositoryType? repoType}) =>
      _c.add(repoType);

  Future<void> close() => _c.close();
}
