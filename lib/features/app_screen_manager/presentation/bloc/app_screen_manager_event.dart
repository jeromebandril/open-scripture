part of 'app_screen_manager_bloc.dart';

sealed class AppScreenManagerEvent extends Equatable {
  const AppScreenManagerEvent();

  @override
  List<Object> get props => [];
}

class AppScreenManagerOpenWindow extends AppScreenManagerEvent {
  final String windowName;

  const AppScreenManagerOpenWindow(this.windowName);

  @override
  List<Object> get props => [windowName];
}

class AppScreenManagerCloseWindow extends AppScreenManagerEvent {}
