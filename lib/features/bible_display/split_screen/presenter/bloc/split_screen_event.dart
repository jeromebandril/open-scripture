part of 'split_screen_bloc.dart';

sealed class SplitScreenEvent extends Equatable {
  const SplitScreenEvent();

  @override
  List<Object?> get props => [];
}

class SplitScreenSubscriptionRequested extends SplitScreenEvent {
  const SplitScreenSubscriptionRequested();

  @override
  List<Object> get props => [];
}

class SplitScreenX extends SplitScreenEvent {
  const SplitScreenX();

  @override
  List<Object> get props => [];
}

class SplitScreenY extends SplitScreenEvent {
  const SplitScreenY();

  @override
  List<Object> get props => [];
}

class SplitScreenMoveFocus extends SplitScreenEvent {
  final int? id;
  final String? direction;

  const SplitScreenMoveFocus({this.direction, this.id});

  @override
  List<Object?> get props => [direction, id];
}

class SplitScreenSendSignal extends SplitScreenEvent {
  final dynamic data;

  const SplitScreenSendSignal({required this.data});

  @override
  List<Object> get props => [data];
}
