import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/shortcuts/domain/models/app_command.dart';
import 'package:open_scripture/features/shortcuts/domain/repositories/shortcuts_repo.dart';

part 'shortcuts_state.dart';

class ShortcutsCubit extends Cubit<ShortcutsState> {
  ShortcutsCubit({required ShortcutsRepo repo})
      : _repo = repo,
        super(ShortcutsState());

  final ShortcutsRepo _repo;

  Future<void> executeCommand(AppCommand command) async {
    _repo.executeCommand(command);
  }
}
