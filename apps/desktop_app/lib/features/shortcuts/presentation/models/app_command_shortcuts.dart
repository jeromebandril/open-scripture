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

final bool _isMacDesktop =
    !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

// for web platform I mostrly replaced ctrl with alt
final Map<AppCommand, ShortcutActivator> appCommandShortcuts = {
  AppCommand.focusSearch: kIsWeb
      ? CharacterActivator('/')
      : SingleActivator(LogicalKeyboardKey.keyL,
          control: !_isMacDesktop, meta: _isMacDesktop, includeRepeats: false),
  AppCommand.toggleHistory: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.keyH,
          alt: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.keyH,
          control: !_isMacDesktop, meta: _isMacDesktop, includeRepeats: false),
  AppCommand.toggleToolbar: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.keyT,
          alt: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.keyT,
          control: !_isMacDesktop, meta: _isMacDesktop, includeRepeats: false),
  AppCommand.toggleFullscreen: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.f11, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.keyF,
          control: !_isMacDesktop, meta: _isMacDesktop, includeRepeats: false),
  AppCommand.changeBible: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.keyB,
          alt: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.keyB,
          control: !_isMacDesktop, meta: _isMacDesktop, includeRepeats: false),
  AppCommand.switchDisplayMode: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.keyM,
          alt: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.keyD,
          control: !_isMacDesktop, meta: _isMacDesktop, includeRepeats: false),
  AppCommand.closeWhatever: const SingleActivator(
    LogicalKeyboardKey.escape,
    includeRepeats: false,
  ),
  // For consistency I still use ALT here.
  // Also for web, to avoid missclicks with arrowUp and arrowDown,
  // I use arrowRight and arrowLeft (with ALT it should block the
  // default browser shortcut, which navigate trough pages)
  AppCommand.nextVerse: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.arrowRight, alt: true)
      : SingleActivator(LogicalKeyboardKey.arrowRight,
          control: !_isMacDesktop, meta: _isMacDesktop),
  AppCommand.prevVerse: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true)
      : SingleActivator(LogicalKeyboardKey.arrowLeft,
          control: !_isMacDesktop, meta: _isMacDesktop),
  //
  AppCommand.removeVerseFromSelection: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.arrowLeft,
          alt: true, shift: true)
      : SingleActivator(LogicalKeyboardKey.arrowLeft,
          control: !_isMacDesktop, meta: _isMacDesktop, shift: true),
  AppCommand.addNextVerseToSelection: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.arrowRight,
          alt: true, shift: true)
      : SingleActivator(LogicalKeyboardKey.arrowRight,
          control: !_isMacDesktop, meta: _isMacDesktop, shift: true),
  AppCommand.nextPane: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.period, alt: true)
      : SingleActivator(LogicalKeyboardKey.tab,
          control: !_isMacDesktop, meta: _isMacDesktop),
  AppCommand.prevPane: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.comma, alt: true)
      : SingleActivator(LogicalKeyboardKey.tab,
          control: !_isMacDesktop, meta: _isMacDesktop, shift: true),
  AppCommand.addPane: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.backslash, alt: true)
      : SingleActivator(LogicalKeyboardKey.backslash,
          control: !_isMacDesktop, meta: _isMacDesktop),
  AppCommand.removePane: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.keyW,
          alt: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.keyW,
          control: !_isMacDesktop, meta: _isMacDesktop, includeRepeats: false),
  AppCommand.movePaneToRight: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.period,
          alt: true, control: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.arrowRight,
          control: !_isMacDesktop,
          meta: _isMacDesktop,
          alt: true,
          includeRepeats: false),
  AppCommand.movePaneToLeft: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.comma,
          alt: true, control: true, includeRepeats: false)
      : SingleActivator(LogicalKeyboardKey.arrowLeft,
          control: !_isMacDesktop,
          meta: _isMacDesktop,
          alt: true,
          includeRepeats: false),
  AppCommand.displayChapterOfSelected: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.enter, alt: true)
      : SingleActivator(LogicalKeyboardKey.enter,
          control: !_isMacDesktop, meta: _isMacDesktop),
  AppCommand.zoomIn: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.equal, alt: true)
      : SingleActivator(LogicalKeyboardKey.equal,
          control: !_isMacDesktop, meta: _isMacDesktop),
  AppCommand.zoomOut: kIsWeb
      ? const SingleActivator(LogicalKeyboardKey.minus, alt: true)
      : SingleActivator(LogicalKeyboardKey.minus,
          control: !_isMacDesktop, meta: _isMacDesktop),
};
