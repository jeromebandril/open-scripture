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
    emit(state.copyWith(isBusy: true));
    if (state.isRunning) return;
    await _repo.start(port: port);
    _sub = _repo.commands.listen(_handleMessage);
    emit(state.copyWith(isRunning: true, isBusy: false));
  }

  Future<void> stop() async {
    emit(state.copyWith(isBusy: true));
    if (!state.isRunning) return;
    await _repo.stop();
    emit(state.copyWith(isRunning: false, isBusy: false));
  }
}
