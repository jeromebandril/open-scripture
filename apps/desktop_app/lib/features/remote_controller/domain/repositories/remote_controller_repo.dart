import 'package:open_scripture/features/remote_controller/domain/entities/client_info.dart';

import '../../../shortcuts/domain/models/app_command.dart';

abstract class RemoteControllerRepo {
  Future<void> start({required int port});
  Future<void> stop();
  Future<void> disconnectClient(ClientId id);

  Stream<AppCommand> get commands;
  Stream<List<ClientInfo>> get clients;
}
