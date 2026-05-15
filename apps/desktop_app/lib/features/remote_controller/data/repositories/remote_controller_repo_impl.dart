import 'dart:async';

import 'package:open_scripture/features/remote_controller/domain/entities/client_info.dart';
import 'package:open_scripture/features/shortcuts/domain/models/app_command.dart';
import 'package:shared/rc_protocol/rc_protocol.dart';

import '../../../../core/systems/remote_controller/remote_command_router.dart';
import '../../domain/repositories/remote_controller_repo.dart';
import '../datasource/remote_controller_ws.dart';

class RemoteControllerRepoImpl implements RemoteControllerRepo {
  RemoteControllerRepoImpl({
    required RemoteControllerWSServer wsServer,
    required RemoteCommandRouter router,
  })  : _wsServer = wsServer,
        _router = router;

  final RemoteControllerWSServer _wsServer;
  final RemoteCommandRouter _router;
  final _controller = StreamController<AppCommand>.broadcast();

  @override
  Stream<AppCommand> get commands => _controller.stream;

  @override
  Stream<List<ClientInfo>> get clients => _wsServer.clientsStream;

  void _handleMessage(RemoteCommand command, ClientId? clientId) {
    if (clientId == null) return;
    if (command.type == RemoteCommandType.command) {
      // convert remote command to AppCommand here
      late final AppCommand appCommand;

      switch (command.name) {
        case 'zoom_in':
          appCommand = AppCommand.zoomIn;
          break;
        case 'zoom_out':
          appCommand = AppCommand.zoomOut;
          break;
        case 'go_next_verse':
          appCommand = AppCommand.nextVerse;
          break;
        case 'go_prev_verse':
          appCommand = AppCommand.prevVerse;
          break;
        default:
          // ignore
          return;
      }
      _controller.add(appCommand);
      return;
    }

    // if custom command, delegate to proper handler
    final response = _router.route(command);
    if (response != null && command.requestId != null) {
      _wsServer.sendToClient(clientId, {
        'response': response,
        'request_id': command.requestId,
      });
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

  @override
  Future<void> disconnectClient(ClientId id) async {
    await _wsServer.disconnectClient(id);
  }
}
