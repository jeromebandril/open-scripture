import 'package:shared/models/remote_command.dart';

// Use this class for handling custom commands
// that are not defined in [AppCommand]
abstract class RemoteCommandCustomHandler {
  void handle(RemoteCommand command);
}
