import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/remote_controller/domain/repositories/remote_controller_repo.dart';

part 'remote_controller_state.dart';

class RemoteControllerCubit extends Cubit<RemoteControllerState> {
  final RemoteControllerRepo _repo;

  RemoteControllerCubit({required RemoteControllerRepo repo})
      : _repo = repo,
        super(RemoteControllerState());

  Future<void> start(int port) async {
    emit(state.copyWith(isBusy: true));
    if (state.isRunning) return;
    await _repo.start(port: port);
    emit(state.copyWith(isRunning: true, isBusy: false));
  }

  Future<void> stop() async {
    emit(state.copyWith(isBusy: true));
    if (!state.isRunning) return;
    await _repo.stop();
    emit(state.copyWith(isRunning: false, isBusy: false));
  }
}
