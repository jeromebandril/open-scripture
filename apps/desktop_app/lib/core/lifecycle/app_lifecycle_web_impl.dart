import 'package:open_scripture/core/infrastructure/window/app_window_manager.dart';
import 'package:open_scripture/core/lifecycle/app_lifecycle.dart';

class WebLifecycleService implements AppLifecycleService {
  final AppWindowManager _windowManager;

  const WebLifecycleService({required AppWindowManager windowManager})
      : _windowManager = windowManager;

  @override
  Future<bool> onExitRequested() async {
    return true;
  }
}
