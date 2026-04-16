import 'package:shared/models/remote_command.dart';

import '../../../../../shared/remote_controller/models/remote_command_handler.dart';
import '../cubit/pane_manager_cubit.dart';

class PaneManagerHandler implements RemoteCommandHandler {
  final PaneManagerCubit bloc;

  const PaneManagerHandler({required this.bloc});

  @override
  void handle(RemoteCommand command) {
    if (command.payload.containsKey('zoom_out')) {
      bloc
          .activePane()
          .textScalerCubit
          .zoomOut(multiplier: command.payload['multiplier'] ?? 1.2);
    }
    if (command.payload.containsKey('zoom_in')) {
      bloc
          .activePane()
          .textScalerCubit
          .zoomIn(multiplier: command.payload['multiplier'] ?? 1.2);
    }
  }
}
