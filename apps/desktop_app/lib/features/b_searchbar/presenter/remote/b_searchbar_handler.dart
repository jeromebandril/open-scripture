import 'package:shared/models/remote_command.dart';

import '../../../../shared/remote_controller/models/remote_command_custom_handler.dart';
import '../bloc/b_searchbar_bloc.dart';

class SearchBarHandler implements RemoteCommandCustomHandler {
  final BSearchbarBloc bloc;

  const SearchBarHandler({required this.bloc});

  @override
  void handle(RemoteCommand command) {
    if (command.name == 'query') {
      bloc.add(BSearchbarParseIntent(command.payload?['query']));
    }
  }
}
