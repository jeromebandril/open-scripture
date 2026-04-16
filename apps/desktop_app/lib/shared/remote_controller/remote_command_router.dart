import 'package:shared/models/remote_command.dart';

import 'remote_command_registry.dart';

class RemoteCommandRouter {
  final RemoteCommandRegistry registry;

  const RemoteCommandRouter({required this.registry});

  void dispatch(RemoteCommand command) {
    registry.get(command.target)!.handle(command);
  }
}
