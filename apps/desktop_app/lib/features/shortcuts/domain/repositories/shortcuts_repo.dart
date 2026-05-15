import 'package:open_scripture/features/shortcuts/domain/models/app_command.dart';

abstract class ShortcutsRepo {
  Future<void> executeCommand(AppCommand command);
}
