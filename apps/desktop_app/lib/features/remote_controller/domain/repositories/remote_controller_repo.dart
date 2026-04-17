import '../../../shortcuts/domain/models/app_command.dart';

abstract class RemoteControllerRepo {
  Future<void> start({required int port});
  Future<void> stop();

  Stream<AppCommand> get commands;
}
