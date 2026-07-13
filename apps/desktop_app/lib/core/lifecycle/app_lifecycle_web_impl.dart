import 'app_lifecycle.dart';

class WebLifecycleService implements AppLifecycleService {
  @override
  Future<bool> onExitRequested() async {
    return true;
  }
}
