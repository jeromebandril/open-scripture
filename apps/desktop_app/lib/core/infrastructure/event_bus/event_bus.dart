import 'dart:async';

abstract class EventBus<T> {
  final StreamController<T> _controller = StreamController<T>.broadcast();

  Stream<T> get stream => _controller.stream;

  void emit(T event) {
    if (_controller.isClosed) return;
    _controller.add(event);
  }

  Future<void> close() => _controller.close();
}
