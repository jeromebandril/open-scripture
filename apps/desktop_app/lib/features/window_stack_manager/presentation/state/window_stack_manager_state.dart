part of 'window_stack_manager_bloc.dart';

typedef WindowBuilder = Widget Function(BuildContext context);

class WindowStackManagerState extends Equatable {
  const WindowStackManagerState({this.windows = const []});

  final List<WidgetBuilder> windows;

  @override
  List<Object?> get props => [windows];
}
