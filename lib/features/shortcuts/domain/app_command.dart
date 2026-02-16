import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppCommand {
  focusSearch,
  toggleHistory,
  nextVerse,
  prevVerse,
  changeBible,
  nextPane,
  prevPane,
  addParallelPane,
  closeCurrentPane,
  toggleToolbar,
  toggleFullscreen,
  switchDisplayMode,
  // private shortcuts
  // do not show as shortcut in the app
  unfocusSearch,
  displayChapterOfSelected,
}

class AppCommandInfo {
  final String label;
  final String description;

  const AppCommandInfo({
    required this.label,
    required this.description,
  });
}

const Map<AppCommand, AppCommandInfo> appCommandInfo = {
  AppCommand.focusSearch: AppCommandInfo(
    label: 'Focus Search',
    description: 'Move keyboard focus to the search field.',
  ),
  AppCommand.toggleHistory: AppCommandInfo(
    label: 'Toggle History',
    description: 'Toggle history view.',
  ),
  AppCommand.nextVerse: AppCommandInfo(
    label: 'Next Verse',
    description: 'Navigate to the next verse in the current pane.',
  ),
  AppCommand.prevVerse: AppCommandInfo(
    label: 'Previous Verse',
    description: 'Navigate to the previous verse in the current pane.',
  ),
  AppCommand.changeBible: AppCommandInfo(
    label: 'Change Bible',
    description: 'Switch the currently selected Bible translation.',
  ),
  AppCommand.nextPane: AppCommandInfo(
    label: 'Next Pane',
    description: 'Move focus to the next pane.',
  ),
  AppCommand.prevPane: AppCommandInfo(
    label: 'Previous Pane',
    description: 'Move focus to the previous pane.',
  ),
  AppCommand.addParallelPane: AppCommandInfo(
    label: 'Add Parallel Pane',
    description: 'Open a new pane alongside the current one.',
  ),
  AppCommand.closeCurrentPane: AppCommandInfo(
    label: 'Close Current Pane',
    description: 'Close the currently active pane.',
  ),
  AppCommand.toggleToolbar: AppCommandInfo(
    label: 'Toggle Toolbar',
    description: 'Show or hide the application toolbar.',
  ),
  AppCommand.toggleFullscreen: AppCommandInfo(
    label: 'Toggle Fullscreen',
    description: 'Enter or exit fullscreen mode.',
  ),
  AppCommand.switchDisplayMode: AppCommandInfo(
    label: 'Switch Display Mode',
    description: 'Switch bible view render type',
  ),
};

const Map<AppCommand, SingleActivator> appCommandShortcuts = {
  AppCommand.focusSearch: SingleActivator(LogicalKeyboardKey.keyL,
      control: true, includeRepeats: false),
  AppCommand.toggleHistory: SingleActivator(LogicalKeyboardKey.keyH,
      control: true, includeRepeats: false),
  AppCommand.toggleToolbar: SingleActivator(LogicalKeyboardKey.keyT,
      control: true, includeRepeats: false),
  AppCommand.toggleFullscreen: SingleActivator(LogicalKeyboardKey.keyF,
      control: true, includeRepeats: false),
  AppCommand.nextVerse:
      SingleActivator(LogicalKeyboardKey.arrowRight, control: true),
  AppCommand.prevVerse:
      SingleActivator(LogicalKeyboardKey.arrowLeft, control: true),
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
