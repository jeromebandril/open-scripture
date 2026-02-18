import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

class FullscreenCubit extends Cubit<bool> {
  FullscreenCubit() : super(false);

  bool _busy = false;

  /// Call once at app startup (after windowManager.ensureInitialized()).
  Future<void> init() async {
    final isFs = await windowManager.isFullScreen();
    if (isClosed) return;
    emit(isFs);
  }

  Future<void> toggle() async {
    if (_busy) return;
    _busy = true;

    try {
      final isFs = await windowManager.isFullScreen();

      // if (!isFs && await windowManager.isMaximized()) {
      //   await windowManager.unmaximize();
      //   await Future.delayed(const Duration(milliseconds: 60));
      // }

      await windowManager.setFullScreen(!isFs);

      // Re-read actual state (more reliable than assuming it succeeded)
      final confirmed = await windowManager.isFullScreen();
      if (!isClosed) emit(confirmed);
    } finally {
      _busy = false;
    }
  }

  Future<void> set(bool value) async {
    if (_busy) return;
    _busy = true;

    try {
      final isFs = await windowManager.isFullScreen();
      if (isFs == value) {
        if (!isClosed) emit(isFs);
        return;
      }

      // Minimize first, because of known bug
      if (value && await windowManager.isMaximized()) {
        await windowManager.unmaximize();
        await Future.delayed(const Duration(milliseconds: 60));
      }

      await windowManager.setFullScreen(value);
      final confirmed = await windowManager.isFullScreen();
      if (!isClosed) emit(confirmed);
    } finally {
      _busy = false;
    }
  }
}
