import 'app_lifecycle.dart';

class DesktopAppLifecycleService implements AppLifecycleService {
  DesktopAppLifecycleService({this.onAppClose});

  final Function()? onAppClose;

  @override
  Future<bool> onExitRequested() async {
    onAppClose?.call();
    return true;
  }
}
