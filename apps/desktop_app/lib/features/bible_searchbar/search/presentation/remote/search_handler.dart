import 'package:shared/rc_protocol/rc_protocol.dart';

import '../../../../../core/systems/remote_controller/models/remote_command_custom_handler.dart';
import '../state/search_bloc.dart';

class SearchBarHandler implements RemoteCommandCustomHandler {
  final SearchBloc bloc;

  const SearchBarHandler({required this.bloc});

  @override
  Map<String, dynamic>? handle(RemoteCommand command) {
    if (command.name == 'query') {
      bloc.add(SearchParseIntent(command.payload?['query']));
    }
    return null;
  }
}
