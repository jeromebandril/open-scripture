import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/app/state/fullscreen_cubit.dart';
import 'package:open_scripture/features/shortcuts/presentation/models/app_command_shortcuts.dart';
import 'package:open_scripture/features/shortcuts/presentation/widgets/shortcut_view.dart';
import 'package:open_scripture/shared/widgets/simple_floating_notification.dart';

import '../../domain/models/app_command.dart';

typedef UiEffectHandler = void Function();

class UiEffectDispatcher {
  UiEffectDispatcher({
    required this.context,
    required this.rootFocusNode,
    required this.searchFocusNode,
    required this.historyFocusNode,
  });

  final BuildContext context;
  final FocusNode rootFocusNode;
  final FocusNode searchFocusNode;
  final FocusNode historyFocusNode;

  void emitEffectFor(AppCommand command) {
    final handler = _handlers[command];
    if (handler == null) return;
    handler();
  }

  late final Map<AppCommand, UiEffectHandler> _handlers = {
    AppCommand.focusSearch: () => searchFocusNode.requestFocus(),
    AppCommand.closeWhatever: () => rootFocusNode.requestFocus(),
    AppCommand.toggleToolbar: () => rootFocusNode.requestFocus(),
    AppCommand.switchDisplayMode: () => rootFocusNode.requestFocus(),
    AppCommand.toggleFullscreen: () {
      if (kIsWeb) return;
      if (context.read<FullscreenCubit>().state) return;

      context.showFloatingNotification(
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
              Text('Press'),
              ShortcutView(
                  fillColor: Theme.of(context).colorScheme.onSurface,
                  textColor: Theme.of(context).colorScheme.surface,
                  borderColor:
                      Theme.of(context).colorScheme.surface.withAlpha(80),
                  activator: appCommandShortcuts[AppCommand.toggleFullscreen]),
              Text('to exit fullscreen'),
            ]),
      );
    }
  };
}
