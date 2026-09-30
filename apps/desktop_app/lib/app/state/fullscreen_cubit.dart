import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/infrastructure/notifications/notification_bus.dart';
import '../../core/infrastructure/window/app_window_manager.dart';

class FullscreenCubit extends Cubit<bool> {
  FullscreenCubit({
    required AppWindowManager window,
    NotificationBus? notificationBus,
  })  : _window = window,
        _notificationBus = notificationBus,
        super(false);

  final AppWindowManager _window;
  final NotificationBus? _notificationBus;

  bool _busy = false;

  Future<void> init() async {
    final isFs = await _window.isFullScreen();
    if (isClosed) return;
    emit(isFs);
  }

  Future<void> toggle() async {
    if (_busy) return;
    _busy = true;
    try {
      final isFs = await _window.isFullScreen();
      await _window.setFullScreen(!isFs);
      final confirmed = await _window.isFullScreen();
      if (!isClosed) emit(confirmed);
    } finally {
      _busy = false;
      _notifyWhenFullscreen();
    }
  }

  Future<void> set(bool value) async {
    if (_busy) return;
    _busy = true;
    try {
      final isFs = await _window.isFullScreen();
      if (isFs == value) {
        if (!isClosed) emit(isFs);
        return;
      }
      if (value && await _window.isMaximized()) {
        await _window.unmaximize();
        await Future.delayed(const Duration(milliseconds: 60));
      }
      await _window.setFullScreen(value);
      final confirmed = await _window.isFullScreen();
      if (!isClosed) emit(confirmed);
    } finally {
      _busy = false;
      _notifyWhenFullscreen();
    }
  }

  void _notifyWhenFullscreen() {
    if (state) _notificationBus?.info("Press  CTRL+F  to exit fullscreen");
  }
}
