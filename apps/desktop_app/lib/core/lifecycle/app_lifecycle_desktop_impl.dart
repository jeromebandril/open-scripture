import '../sword/sword_bridge.dart';
import 'app_lifecycle.dart';

class DesktopAppLifecycleService implements AppLifecycleService {
  final SwordBridge _bridge;
  DesktopAppLifecycleService({required SwordBridge bridge}) : _bridge = bridge;

  @override
  Future<bool> onExitRequested() async {
    _bridge.shutdown();
    return true;
  }
}
