import 'dart:async';

class InstallNotifier {
  final _c = StreamController<String>.broadcast();
  Stream<String> get stream => _c.stream;

  void installed(String bibleId) => _c.add(bibleId);

  Future<void> close() => _c.close();
}
