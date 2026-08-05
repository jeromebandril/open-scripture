import 'app_command.dart';

enum AppCommandScope { main, navigation, pane, interface, other }

extension AppCommandScopeX on AppCommandScope {
  String get displayName => name[0].toUpperCase() + name.substring(1);
}

class AppCommandInfo {
  final String label;
  final String description;
  final AppCommandScope? scope;

  const AppCommandInfo({
    required this.label,
    required this.description,
    this.scope,
  });
}

class AppCommandGroup {
  final AppCommandScope scope;
  final Map<AppCommand, AppCommandInfo> commands;

  const AppCommandGroup({
    required this.scope,
    required this.commands,
  });
}

const List<AppCommandGroup> appCommandGroups = [
  AppCommandGroup(
    scope: AppCommandScope.main,
    commands: {
      AppCommand.focusSearch: AppCommandInfo(
        label: 'Focus Search',
        description: 'Move keyboard focus to the search field.',
      ),
      AppCommand.changeBible: AppCommandInfo(
        label: 'Change Bible',
        description: 'Switch the currently selected Bible translation.',
      ),
      AppCommand.switchDisplayMode: AppCommandInfo(
        label: 'Switch Display Mode',
        description: 'Switch the Bible view between available render modes.',
      ),
    },
  ),
  AppCommandGroup(
    scope: AppCommandScope.navigation,
    commands: {
      AppCommand.nextVerse: AppCommandInfo(
        label: 'Next Verse',
        description: 'Navigate to the next verse in the current pane.',
      ),
      AppCommand.prevVerse: AppCommandInfo(
        label: 'Previous Verse',
        description: 'Navigate to the previous verse in the current pane.',
      ),
      AppCommand.addNextVerseToSelection: AppCommandInfo(
        label: 'Add Next Verse to Selection',
        description: 'Extend the current verse selection by one verse forward.',
      ),
      AppCommand.removeVerseFromSelection: AppCommandInfo(
        label: 'Remove Verse from Selection',
        description: 'Shrink the current verse selection by one verse.',
      ),
    },
  ),
  AppCommandGroup(
    scope: AppCommandScope.interface,
    commands: {
      AppCommand.toggleFullscreen: AppCommandInfo(
        label: 'Toggle Fullscreen',
        description: 'Enter/exit fullscreen mode.',
      ),
      AppCommand.toggleHistory: AppCommandInfo(
        label: 'Toggle History',
        description: 'Show/Hide the navigation history panel.',
      ),
      AppCommand.toggleToolbar: AppCommandInfo(
        label: 'Toggle Toolbar',
        description: 'Show/Hide the application toolbar.',
      ),
      AppCommand.zoomIn: AppCommandInfo(
        label: 'Zoom In',
        description: 'Increase the zoom level of the current view.',
      ),
      AppCommand.zoomOut: AppCommandInfo(
        label: 'Zoom Out',
        description: 'Decrease the zoom level of the current view.',
      ),
    },
  ),
  AppCommandGroup(
    scope: AppCommandScope.pane,
    commands: {
      AppCommand.addPane: AppCommandInfo(
        label: 'Add new Pane',
        description: 'Open a new pane alongside the current one.',
      ),
      AppCommand.removePane: AppCommandInfo(
        label: 'Close current Pane',
        description: 'Close the current active pane.',
      ),
      AppCommand.nextPane: AppCommandInfo(
        label: 'Next Pane',
        description: 'Move focus to the next pane.',
      ),
      AppCommand.prevPane: AppCommandInfo(
        label: 'Previous Pane',
        description: 'Move focus to the previous pane.',
      ),
      AppCommand.movePaneToLeft: AppCommandInfo(
        label: 'Move Pane Left',
        description: 'Swap the active pane with the left',
      ),
      AppCommand.movePaneToRight: AppCommandInfo(
        label: 'Move Pane Right',
        description: 'Swap the active pane with the right.',
      ),
    },
  ),
  AppCommandGroup(scope: AppCommandScope.other, commands: {
    AppCommand.flushOverlayBuffer: AppCommandInfo(
      label: 'Update overlay',
      description: 'Send the current selected verse reference to the overlay',
    ),
  })
];
