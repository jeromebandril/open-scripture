part of 'window_stack_manager_bloc.dart';

sealed class WindowStackManagerEvent extends Equatable {
  const WindowStackManagerEvent();

  @override
  List<Object?> get props => [];
}

class WindowStackManagerOpen extends WindowStackManagerEvent {
  final String? title;
  final Widget widget;
  final Size? maxSize;
  final bool isSelfManaged;

  const WindowStackManagerOpen({
    required this.title,
    required this.widget,
    required this.maxSize,
  }) : isSelfManaged = false;

  const WindowStackManagerOpen.selfManaged({required this.widget})
      : title = null,
        maxSize = null,
        isSelfManaged = true;

  @override
  List<Object?> get props => [title, widget, maxSize];
}

class WindowStackManagerClose extends WindowStackManagerEvent {
  const WindowStackManagerClose();

  @override
  List<Object> get props => [];
}
