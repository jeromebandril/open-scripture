import 'package:flutter/widgets.dart';

import '../../domain/models/app_command.dart';

typedef UiEffectHandler = void Function();

class UiEffectDispatcher {
  UiEffectDispatcher({
    required this.rootFocusNode,
    required this.searchFocusNode,
    required this.historyFocusNode,
  });

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
    AppCommand.unfocusSearch: () => rootFocusNode.requestFocus(),
    AppCommand.toggleMenubar: () => rootFocusNode.requestFocus(),
    AppCommand.switchDisplayMode: () => rootFocusNode.requestFocus(),
  };
}
