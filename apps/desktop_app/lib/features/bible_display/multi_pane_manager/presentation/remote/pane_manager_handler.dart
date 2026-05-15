import 'package:open_scripture/features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/display_mode.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/state/installed_bibles/installed_bibles_bloc.dart';
import 'package:shared/rc_protocol/rc_protocol.dart';

import '../../../../../core/systems/remote_controller/models/remote_command_custom_handler.dart';
import '../state/multi_pane_manager_cubit.dart';

class PaneManagerHandler implements RemoteCommandCustomHandler {
  final MultiPaneManagerCubit multiPaneManagerCubit;
  final InstalledBiblesBloc installedBiblesBloc;

  const PaneManagerHandler({
    required this.multiPaneManagerCubit,
    required this.installedBiblesBloc,
  });

  @override
  Map<String, dynamic>? handle(RemoteCommand command) {
    if (command.name == 'zoom_out') {
      multiPaneManagerCubit
          .activePane()
          .textScalerCubit
          .zoomOut(multiplier: command.payload?['multiplier'] ?? 1);
    }
    if (command.name == 'zoom_in') {
      multiPaneManagerCubit
          .activePane()
          .textScalerCubit
          .zoomIn(multiplier: command.payload?['multiplier'] ?? 1);
    }
    if (command.name == 'switch_display_mode') {
      late final BiblePaneEvent evt;
      evt = command.payload?['display_mode'] == 0
          ? BiblePaneSetDisplayMode(DisplayMode.list)
          : BiblePaneSetDisplayMode(DisplayMode.presentation);

      multiPaneManagerCubit.activePane().bloc.add(evt);
    }
    if (command.name == 'get_installed_bibles') {
      return {
        'current':
            multiPaneManagerCubit.activePane().bloc.state.openedBiblesIds,
        'bibles': installedBiblesBloc.state.installedBibles
            .map((b) => {
                  'id': b.id,
                  'name': b.bibleName,
                  'abbreviation': b.abbreviation,
                  'language': b.langEngName,
                })
            .toList(),
      };
    }
    if (command.name == 'select_bibles') {
      final ids = (command.payload?['ids'] as List?)?.cast<int>() ?? [];
      multiPaneManagerCubit.activePane().bloc.add(BiblePaneOpen(ids));
    }

    return null;
  }
}
