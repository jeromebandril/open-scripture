import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../shortcuts/domain/models/app_command.dart';
import '../../../shortcuts/presentation/models/app_command_dispatcher.dart';
import '../../domain/entities/client_info.dart';
import '../../domain/repositories/remote_controller_repo.dart';

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
  StreamSubscription? _subClients;

  void _handleMessage(AppCommand command) {
    dispatcher.dispatch(command);
  }

  Future<void> start(int port) async {
    if (state.isRunning || _sub != null) return;

    if (state.isBusy) return;
    emit(state.copyWith(isBusy: true));

    await _repo.start(port: port);

    await _sub?.cancel();
    await _subClients?.cancel();
    _sub = _repo.commands.listen(_handleMessage);
    _subClients = _repo.clients.listen(_refreshConnectedClients);

    emit(state.copyWith(isRunning: true, isBusy: false));
  }

  Future<void> stop() async {
    if (state.isBusy || !state.isRunning) return;

    emit(state.copyWith(isBusy: true));

    await _repo.stop();

    await _sub?.cancel();
    _sub = null;
    await _subClients?.cancel();
    _subClients = null;

    emit(state.copyWith(isRunning: false, isBusy: false));
  }

  void _refreshConnectedClients(List<ClientInfo> clients) {
    emit(state.copyWith(connectedClients: clients));
  }

  Future<void> disconnectClient(ClientId id) async {
    await _repo.disconnectClient(id);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _subClients?.cancel();
    return super.close();
  }
}
