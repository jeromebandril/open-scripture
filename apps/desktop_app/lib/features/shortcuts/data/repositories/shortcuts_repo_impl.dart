import 'package:open_scripture/features/shortcuts/domain/models/app_command.dart';
import 'package:open_scripture/features/shortcuts/domain/repositories/shortcuts_repo.dart';
import 'package:open_scripture/features/shortcuts/presentation/models/app_command_dispatcher.dart';

class ShortcutsRepoImpl implements ShortcutsRepo {
  final AppCommandDispatcher _dispatcher;

  const ShortcutsRepoImpl({required AppCommandDispatcher dispatcher})
      : _dispatcher = dispatcher;

  @override
  Future<void> executeCommand(AppCommand command) async {
    _dispatcher.dispatch(command);
    return;
  }
}
