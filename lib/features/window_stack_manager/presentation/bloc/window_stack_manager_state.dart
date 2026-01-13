part of 'window_stack_manager_bloc.dart';

typedef WindowBuilder = Widget Function(BuildContext context);

class WindowStackManagerState extends Equatable {
  const WindowStackManagerState({this.window});

  final WidgetBuilder? window;

  @override
  List<Object?> get props => [window];
}
