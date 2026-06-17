import 'package:open_scripture/core/lifecycle/app_lifecycle.dart';

class WebLifecycleService implements AppLifecycleService {
  @override
  Future<bool> onExitRequested() async {
    return true;
  }
}
