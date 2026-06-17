import 'dart:js_interop';

import 'package:open_scripture/core/infrastructure/window/app_window_manager.dart';
import 'package:web/web.dart' as web;

class WindowManagerImpl extends AppWindowManager {
  @override
  Future<bool> isFullScreen() {
    return Future.value(web.document.fullscreenElement != null);
  }

  @override
  Future<void> setFullScreen(bool value) async {
    if (value) {
      await (web.document.documentElement?.requestFullscreen())?.toDart;
    } else {
      await web.document.exitFullscreen().toDart;
    }
  }

  void _onBeforeUnload(web.Event event) => event.preventDefault();

  @override
  void toggleExitGuard(bool preventExit) {
    if (preventExit) {
      web.window.onbeforeunload = _onBeforeUnload.toJS;
    } else {
      web.window.onbeforeunload = null;
    }
  }
}
