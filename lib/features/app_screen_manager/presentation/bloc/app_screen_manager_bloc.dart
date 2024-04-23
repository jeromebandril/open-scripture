import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_screen_manager_event.dart';
part 'app_screen_manager_state.dart';

class AppScreenManagerBloc
    extends Bloc<AppScreenManagerEvent, AppScreenManagerState> {
  AppScreenManagerBloc() : super(const AppScreenManagerState()) {
    on<AppScreenManagerOpenWindow>(_onOpenWindow);
    on<AppScreenManagerCloseWindow>(_onCloseWindow);
  }

  Future<void> _onOpenWindow(
    AppScreenManagerOpenWindow event,
    Emitter<AppScreenManagerState> emit,
  ) async {
    emit(state.copyWith(
      status: () => AppScreenManagerStatus.open,
      currentOpenWindow: () => event.windowName,
    ));
  }

  Future<void> _onCloseWindow(
    AppScreenManagerCloseWindow event,
    Emitter<AppScreenManagerState> emit,
  ) async {
    emit(state.copyWith(
      status: () => AppScreenManagerStatus.close,
      currentOpenWindow: () => null,
    ));
  }
}
