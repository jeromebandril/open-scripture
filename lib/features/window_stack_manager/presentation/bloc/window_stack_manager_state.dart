part of 'window_stack_manager_bloc.dart';

class WindowStackManagerState extends Equatable {
  const WindowStackManagerState({this.window});

  final Widget? window;

  @override
  List<Object?> get props => [window];
}
