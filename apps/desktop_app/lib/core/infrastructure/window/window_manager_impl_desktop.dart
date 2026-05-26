import 'package:open_scripture/core/infrastructure/window/app_window_manager.dart';
import 'package:window_manager/window_manager.dart';

class WindowManagerImpl implements AppWindowManager {
  @override
  Future<void> init() => windowManager.ensureInitialized();
  @override
  Future<bool> isFullScreen() => windowManager.isFullScreen();
  @override
  Future<void> setFullScreen(bool value) => windowManager.setFullScreen(value);
  @override
  Future<bool> isMaximized() => windowManager.isMaximized();
  @override
  Future<void> unmaximize() => windowManager.unmaximize();
}
