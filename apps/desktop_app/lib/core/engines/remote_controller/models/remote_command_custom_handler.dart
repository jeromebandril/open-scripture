import 'package:shared/rc_protocol/rc_protocol.dart';

// Use this class for handling custom commands
// that are not defined in [AppCommand]
abstract class RemoteCommandCustomHandler {
  Map<String, dynamic>? handle(RemoteCommand command);
}
