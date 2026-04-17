import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/remote_controller/domain/repositories/remote_controller_repo.dart';
import 'package:open_scripture/features/shortcuts/domain/models/app_command.dart';

import '../../../../shortcuts/presentation/models/app_command_dispatcher.dart';

part 'remote_controller_state.dart';

class RemoteControllerCubit extends Cubit<RemoteControllerState> {
  RemoteControllerCubit({
    required RemoteControllerRepo repo,
    required this.dispatcher,
  })  : _repo = repo,
        super(RemoteControllerState());

  final RemoteControllerRepo _repo;
  final AppCommandDispatcher dispatcher;

  StreamSubscription? _sub;

  void _handleMessage(AppCommand command) {
    dispatcher.dispatch(command);
  }

  Future<void> start(int port) async {
    if (state.isRunning || _sub != null) return;

    if (state.isBusy) return;
    emit(state.copyWith(isBusy: true));

    await _repo.start(port: port);

    await _sub?.cancel();
    _sub = _repo.commands.listen(_handleMessage);

    emit(state.copyWith(isRunning: true, isBusy: false));
  }

  Future<void> stop() async {
    if (state.isBusy || !state.isRunning) return;

    emit(state.copyWith(isBusy: true));

    await _repo.stop();

    await _sub?.cancel();
    _sub = null;

    emit(state.copyWith(isRunning: false, isBusy: false));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
