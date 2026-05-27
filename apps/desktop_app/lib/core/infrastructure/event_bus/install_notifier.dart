import 'dart:async';

/// Doesn't stream any data. Its purpose is to send signal whenever
/// a bible gets installed, so it can sync with [MylibraryCubit]
class InstallNotifier {
  final _c = StreamController<void>.broadcast();
  Stream<void> get stream => _c.stream;

  void refreshInstalledList() => _c.add(null);

  Future<void> close() => _c.close();
}
