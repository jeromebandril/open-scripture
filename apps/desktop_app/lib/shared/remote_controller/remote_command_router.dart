import 'package:shared/models/remote_command.dart';
import 'package:shared/models/remote_command_type.dart';

import 'models/remote_command_custom_handler.dart';

class RemoteCommandRouter {
  const RemoteCommandRouter({
    required Map<String, RemoteCommandCustomHandler> handlers,
  }) : _handlers = handlers;

  final Map<String, RemoteCommandCustomHandler> _handlers;

  void route(RemoteCommand command) {
    //
    // Execute only custom commands
    // i.e. those not defined in the default AppCommand
    // with custom parameters
    //
    if (command.type != RemoteCommandType.custom) return;
    _handlers[command.target]?.handle(command);
  }
}
