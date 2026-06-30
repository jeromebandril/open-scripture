import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/models/app_command.dart';
import '../../domain/repositories/shortcuts_repo.dart';

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
