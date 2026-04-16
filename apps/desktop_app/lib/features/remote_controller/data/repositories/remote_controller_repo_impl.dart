import 'dart:io';

import 'package:shared/models/remote_command.dart';

import '../../../../shared/remote_controller/remote_command_router.dart';
import '../../domain/repositories/remote_controller_repo.dart';
import '../datasource/remote_controller_ws.dart';

class RemoteControllerRepoImpl implements RemoteControllerRepo {
  final RemoteControllerWSServer _wsServer;
  final RemoteCommandRouter _router;

  const RemoteControllerRepoImpl({
    required RemoteControllerWSServer wsServer,
    required RemoteCommandRouter router,
  })  : _wsServer = wsServer,
        _router = router;

  void _handleMessage(RemoteCommand command, WebSocket client) {
    _router.dispatch(command);
  }

  @override
  Future<void> start({required int port}) {
    return _wsServer.start(port: port, onMessage: _handleMessage);
  }

  @override
  Future<void> stop() {
    return _wsServer.stop();
  }
}
