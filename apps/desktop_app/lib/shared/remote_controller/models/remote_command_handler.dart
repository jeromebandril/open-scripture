import 'package:shared/models/remote_command.dart';

abstract class RemoteCommandHandler {
  void handle(RemoteCommand command);
}
