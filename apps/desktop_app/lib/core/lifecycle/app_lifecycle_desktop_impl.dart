import 'package:open_scripture/core/lifecycle/app_lifecycle.dart';
import 'package:open_scripture/core/sword/sword_bridge.dart';

class DesktopAppLifecycleService implements AppLifecycleService {
  final SwordBridge _bridge;
  DesktopAppLifecycleService({required SwordBridge bridge}) : _bridge = bridge;

  @override
  Future<void> onExitRequested() async {
    _bridge.shutdown();
  }
}
