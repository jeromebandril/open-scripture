part of 'window_stack_manager_bloc.dart';

sealed class WindowStackManagerEvent extends Equatable {
  const WindowStackManagerEvent();

  @override
  List<Object> get props => [];
}

class WindowStackManagerOpen extends WindowStackManagerEvent {
  final Widget window;

  const WindowStackManagerOpen(this.window);

  @override
  List<Object> get props => [window];
}

class WindowStackManagerClose extends WindowStackManagerEvent {
  const WindowStackManagerClose();

  @override
  List<Object> get props => [];
}
