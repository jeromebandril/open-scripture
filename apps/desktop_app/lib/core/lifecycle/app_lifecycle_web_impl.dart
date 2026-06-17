import 'package:open_scripture/core/lifecycle/app_lifecycle.dart';

class NoOpAppLifecycleService implements AppLifecycleService {
  @override
  Future<void> onExitRequested() async {}
}
