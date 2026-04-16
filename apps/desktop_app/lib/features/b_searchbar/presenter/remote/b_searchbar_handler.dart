import 'package:shared/models/remote_command.dart';

import '../../../../shared/remote_controller/models/remote_command_handler.dart';
import '../bloc/b_searchbar_bloc.dart';

class SearchBarHandler implements RemoteCommandHandler {
  final BSearchbarBloc bloc;

  const SearchBarHandler({required this.bloc});

  @override
  void handle(RemoteCommand command) {
    if (command.payload.containsKey('query')) {
      bloc.add(BSearchbarParseIntent(command.payload['query']));
    }
  }
}
