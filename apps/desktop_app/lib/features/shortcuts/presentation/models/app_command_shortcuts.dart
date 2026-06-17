import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../domain/models/app_command.dart';
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

// for web platform I mostrly replaced ctrl with alt
const Map<AppCommand, SingleActivator> appCommandShortcuts = {
  AppCommand.focusSearch: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.keyL,
          alt: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.keyL,
          control: true, includeRepeats: false),

  AppCommand.toggleHistory: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.keyH,
          alt: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.keyH,
          control: true, includeRepeats: false),

  AppCommand.toggleToolbar: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.keyT,
          alt: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.keyT,
          control: true, includeRepeats: false),

  AppCommand.toggleFullscreen: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.f11)
      : SingleActivator(LogicalKeyboardKey.keyF,
          control: true, includeRepeats: false),

  AppCommand.changeBible: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.keyB,
          alt: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.keyB,
          control: true, shift: true, includeRepeats: false),

  AppCommand.switchDisplayMode: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.keyD,
          alt: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.keyD,
          control: true, shift: true, includeRepeats: false),

  AppCommand.closeWhatever: SingleActivator(
    LogicalKeyboardKey.escape,
    includeRepeats: false,
  ),

  // Navigation (Verses)
  // Note: Alt + Arrow avoids macOS Mission Control workspace switching conflicts
  AppCommand.nextVerse: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.arrowRight, alt: true)
      : SingleActivator(LogicalKeyboardKey.arrowRight, control: true),

  AppCommand.prevVerse: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true)
      : SingleActivator(LogicalKeyboardKey.arrowLeft, control: true),

  // Verse Selection
  AppCommand.removeVerseFromSelection: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true, shift: true)
      : SingleActivator(LogicalKeyboardKey.arrowLeft,
          control: true, shift: true),

  AppCommand.addNextVerseToSelection: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.arrowRight, alt: true, shift: true)
      : SingleActivator(LogicalKeyboardKey.arrowRight,
          control: true, shift: true),

  // Multi-Pane Management
  AppCommand.nextPane: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.period, alt: true)
      : SingleActivator(LogicalKeyboardKey.tab, control: true),

  AppCommand.prevPane: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.comma, alt: true)
      : SingleActivator(LogicalKeyboardKey.tab, control: true, shift: true),

  AppCommand.addPane: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.backslash, alt: true)
      : SingleActivator(LogicalKeyboardKey.backslash, control: true),

  AppCommand.removePane: kIsWeb
      ? SingleActivator(LogicalKeyboardKey.keyW,
          alt: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.keyW,
          control: true, includeRepeats: false),

  AppCommand.movePaneToRight: SingleActivator(
    LogicalKeyboardKey.arrowRight,
    control: true,
    alt: true,
    includeRepeats: false,
  ),
  AppCommand.movePaneToLeft: SingleActivator(
    LogicalKeyboardKey.arrowLeft,
    control: true,
    alt: true,
    includeRepeats: false,
  ),
  AppCommand.displayChapterOfSelected: SingleActivator(
    LogicalKeyboardKey.enter,
    control: true,
  ),
  AppCommand.zoomIn: SingleActivator(
    LogicalKeyboardKey.equal,
    control: true,
  ),
  AppCommand.zoomOut: SingleActivator(
    LogicalKeyboardKey.minus,
    control: true,
  ),
};
