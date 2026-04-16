import 'dart:io';

import 'package:open_scripture/features/remote_controller/data/datasource/remote_controller_ws.dart';
import 'package:open_scripture/features/remote_controller/domain/repositories/remote_controller_repo.dart';
import 'package:shared/command.dart';

class RemoteControllerRepoImpl implements RemoteControllerRepo {
  final RemoteControllerWSServer _wsServer;

  const RemoteControllerRepoImpl({required RemoteControllerWSServer wsServer})
      : _wsServer = wsServer;

  void _handleMessage(Command command, WebSocket client) {
    switch (command.type) {
      case 'play':
        // domain logic
        break;
    }
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
