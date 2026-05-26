import 'package:open_scripture/core/infrastructure/window/app_window_manager.dart';
import 'package:web/web.dart' as web;

class WindowManagerImpl extends AppWindowManager {
  @override
  Future<bool> isFullScreen() async {
    return web.document.fullscreenElement != null;
  }

  @override
  Future<void> setFullScreen(bool value) async {
    if (value) {
      web.document.documentElement?.requestFullscreen();
    } else {
      web.document.exitFullscreen();
    }
  }
}
