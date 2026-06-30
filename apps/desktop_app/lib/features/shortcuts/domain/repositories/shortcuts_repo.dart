import '../models/app_command.dart';

abstract class ShortcutsRepo {
  Future<void> executeCommand(AppCommand command);
}
