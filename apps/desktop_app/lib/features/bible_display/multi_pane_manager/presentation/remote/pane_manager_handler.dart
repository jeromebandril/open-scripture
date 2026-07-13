import 'package:shared/rc_protocol/rc_protocol.dart';

import '../../../../../core/engines/remote_controller/models/remote_command_custom_handler.dart';
import '../../../../../shared/domain/entities/bible_id.dart';
import '../../../../my_library/presentation/cubit/my_library_cubit.dart';
import '../../../bible_pane/domain/display_mode.dart';
import '../../../bible_pane/presentation/state/bible_pane_bloc.dart';
import '../state/multi_pane_manager_cubit.dart';

class PaneManagerHandler implements RemoteCommandCustomHandler {
  final MultiPaneManagerCubit _multiPaneManagerCubit;
  final MyLibraryCubit _myLibraryCubit;

  const PaneManagerHandler({
    required MultiPaneManagerCubit multiPaneManagerCubit,
    required MyLibraryCubit myLibraryCubit,
  })  : _multiPaneManagerCubit = multiPaneManagerCubit,
        _myLibraryCubit = myLibraryCubit;

  @override
  Map<String, dynamic>? handle(RemoteCommand command) {
    if (command.name == 'zoom_out') {
      _multiPaneManagerCubit
          .activePane()
          .textScalerCubit
          .zoomOut(multiplier: command.payload?['multiplier'] ?? 1);
    }
    if (command.name == 'zoom_in') {
      _multiPaneManagerCubit
          .activePane()
          .textScalerCubit
          .zoomIn(multiplier: command.payload?['multiplier'] ?? 1);
    }
    if (command.name == 'switch_display_mode') {
      late final BiblePaneEvent evt;
      evt = command.payload?['display_mode'] == 0
          ? BiblePaneSetDisplayMode(DisplayMode.list)
          : BiblePaneSetDisplayMode(DisplayMode.presentation);

      _multiPaneManagerCubit.activePane().bloc.add(evt);
    }
    if (command.name == 'get_installed_bibles') {
      return {
        'current':
            _multiPaneManagerCubit.activePane().bloc.state.openedBiblesIds,
        'bibles': _myLibraryCubit.state.bibles
            .map((b) => {
                  'id': b.localId,
                  'name': b.name,
                  'abbreviation': b.abbreviation,
                  'language': b.langEngName,
                })
            .toList(),
      };
    }
    if (command.name == 'select_bibles') {
      // TODO: this is surely broken, because I'm not syncing it with the refactors
      final ids = (command.payload?['ids'] as List?)?.cast<BibleId>() ?? [];
      // TODO: support other repositories
      _multiPaneManagerCubit
          .activePane()
          .bloc
          .add(BiblePaneOpen(bibleIds: ids));
    }

    return null;
  }
}
