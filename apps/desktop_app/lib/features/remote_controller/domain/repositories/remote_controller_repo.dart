import '../../../shortcuts/domain/models/app_command.dart';
import '../entities/client_info.dart';

abstract class RemoteControllerRepo {
  Future<void> start({required int port});
  Future<void> stop();
  Future<void> disconnectClient(ClientId id);

  Stream<AppCommand> get commands;
  Stream<List<ClientInfo>> get clients;
}
