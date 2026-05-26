export 'window_manager_impl_desktop.dart'
    if (dart.library.html) 'window_manager_impl_web.dart';

abstract class AppWindowManager {
  Future<void> init() async {}
  Future<bool> isFullScreen() async => false;
  Future<void> setFullScreen(bool value) async {}
  Future<bool> isMaximized() async => false;
  Future<void> unmaximize() async {}
}
