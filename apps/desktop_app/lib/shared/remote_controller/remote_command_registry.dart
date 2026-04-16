import 'models/remote_command_handler.dart';

class RemoteCommandRegistry {
  final Map<String, RemoteCommandHandler> _handlers;

  const RemoteCommandRegistry({
    required Map<String, RemoteCommandHandler> handlers,
  }) : _handlers = handlers;

  RemoteCommandHandler? get(String target) => _handlers[target];
}
