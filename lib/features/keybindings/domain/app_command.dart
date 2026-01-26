import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppCommand {
  focusSearch,
  nextVerse,
  prevVerse,
  changeBible,
  nextPane,
  prevPane,
  addParallelPane,
  deleteCurrentPane,
  toggleToolbar,
  toggleFullscreen,
  switchDisplayMode,
  unfocusSearch, // do not show as shortcut in the app
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
  AppCommand.deleteCurrentPane: AppCommandInfo(
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
  AppCommand.focusSearch:
      SingleActivator(LogicalKeyboardKey.keyL, control: true),
  AppCommand.toggleToolbar:
      SingleActivator(LogicalKeyboardKey.keyT, control: true),
  AppCommand.toggleFullscreen:
      SingleActivator(LogicalKeyboardKey.keyF, control: true),
  AppCommand.nextVerse:
      SingleActivator(LogicalKeyboardKey.arrowRight, control: true),
  AppCommand.prevVerse:
      SingleActivator(LogicalKeyboardKey.arrowLeft, control: true),
  AppCommand.nextPane: SingleActivator(
    LogicalKeyboardKey.arrowRight,
    control: true,
    shift: true,
  ),
  AppCommand.prevPane: SingleActivator(
    LogicalKeyboardKey.arrowLeft,
    control: true,
    shift: true,
  ),
  AppCommand.changeBible: SingleActivator(
    LogicalKeyboardKey.keyB,
    control: true,
    shift: true,
  ),
  AppCommand.switchDisplayMode: SingleActivator(
    LogicalKeyboardKey.keyD,
    control: true,
    shift: true,
  ),
  AppCommand.unfocusSearch: SingleActivator(
    LogicalKeyboardKey.escape,
  ),
};
