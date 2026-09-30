import 'package:flutter/material.dart';

import '../../../../app/extensions/build_context_extensions.dart';
import '../../../settings_window/presentation/pages/settings_window.dart';
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
    AppCommand.openSettings: () =>
        context.pushWindow(builder: (_) => const SettingsWindow()),
  };
}
