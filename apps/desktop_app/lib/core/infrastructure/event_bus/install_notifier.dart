import 'dart:async';

class InstallNotifier {
  final _c = StreamController<void>.broadcast();
  Stream<void> get stream => _c.stream;

  void refreshInstalledList() => _c.add(null);

  Future<void> close() => _c.close();
}
