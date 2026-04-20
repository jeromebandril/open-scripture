import 'package:open_scripture/features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/models/display_mode.dart';
import 'package:shared/rc_protocol/rc_protocol.dart';

import '../../../../../shared/remote_controller/models/remote_command_custom_handler.dart';
import '../cubit/pane_manager_cubit.dart';

class PaneManagerHandler implements RemoteCommandCustomHandler {
  final PaneManagerCubit bloc;

  const PaneManagerHandler({required this.bloc});

  @override
  void handle(RemoteCommand command) {
    if (command.name == 'zoom_out') {
      bloc
          .activePane()
          .textScalerCubit
          .zoomOut(multiplier: command.payload?['multiplier'] ?? 1);
    }
    if (command.name == 'zoom_in') {
      bloc
          .activePane()
          .textScalerCubit
          .zoomIn(multiplier: command.payload?['multiplier'] ?? 1);
    }
    if (command.name == 'switch_display_mode') {
      late final BiblePaneEvent evt;
      evt = command.payload?['display_mode'] == 0
          ? BiblePaneSetDisplayMode(DisplayMode.normal)
          : BiblePaneSetDisplayMode(DisplayMode.presentation);

      bloc.activePane().bloc.add(evt);
    }
  }
}
