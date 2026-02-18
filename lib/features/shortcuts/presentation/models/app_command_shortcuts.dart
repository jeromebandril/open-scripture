import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../domain/app_command.dart';
import 'app_command_intent.dart';

Map<ShortcutActivator, Intent> buildShortcutIntentMap(
  Map<AppCommand, SingleActivator> source,
) {
  final result = <ShortcutActivator, Intent>{};

  for (final entry in source.entries) {
    result[entry.value] = AppCommandIntent(entry.key);
  }

  return result;
}

const Map<AppCommand, SingleActivator> appCommandShortcuts = {
  AppCommand.focusSearch: SingleActivator(
    LogicalKeyboardKey.keyL,
    control: true,
    includeRepeats: false,
  ),
  AppCommand.toggleHistory: SingleActivator(
    LogicalKeyboardKey.keyH,
    control: true,
    includeRepeats: false,
  ),
  AppCommand.toggleToolbar: SingleActivator(
    LogicalKeyboardKey.keyT,
    control: true,
    includeRepeats: false,
  ),
  AppCommand.toggleFullscreen: SingleActivator(
    LogicalKeyboardKey.keyF,
    control: true,
    includeRepeats: false,
  ),
  AppCommand.nextVerse: SingleActivator(
    LogicalKeyboardKey.arrowRight,
    control: true,
  ),
  AppCommand.prevVerse: SingleActivator(
    LogicalKeyboardKey.arrowLeft,
    control: true,
  ),
  AppCommand.removeVerseFromSelection: SingleActivator(
    LogicalKeyboardKey.arrowLeft,
    control: true,
    shift: true,
  ),
  AppCommand.addNextVerseToSelection: SingleActivator(
      LogicalKeyboardKey.arrowRight,
      control: true,
      shift: true),
  AppCommand.nextPane: SingleActivator(
    LogicalKeyboardKey.tab,
    control: true,
  ),
  AppCommand.prevPane: SingleActivator(
    LogicalKeyboardKey.tab,
    control: true,
    shift: true,
  ),
  AppCommand.changeBible: SingleActivator(
    LogicalKeyboardKey.keyB,
    control: true,
    shift: true,
    includeRepeats: false,
  ),
  AppCommand.switchDisplayMode: SingleActivator(
    LogicalKeyboardKey.keyD,
    control: true,
    shift: true,
    includeRepeats: false,
  ),
  AppCommand.unfocusSearch: SingleActivator(
    LogicalKeyboardKey.escape,
    includeRepeats: false,
  ),
  AppCommand.displayChapterOfSelected: SingleActivator(
    LogicalKeyboardKey.enter,
    control: true,
  ),
  AppCommand.addParallelPane: SingleActivator(
    LogicalKeyboardKey.backslash,
    control: true,
  ),
  AppCommand.closeCurrentPane: SingleActivator(
    LogicalKeyboardKey.keyW,
    control: true,
  ),
};
