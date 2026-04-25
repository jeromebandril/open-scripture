import 'package:shared/rc_protocol/rc_protocol.dart';

import '../../../../core/systems/remote_controller/models/remote_command_custom_handler.dart';
import '../state/b_searchbar_bloc.dart';

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
