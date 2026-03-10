enum AppCommand {
  focusSearch,
  toggleHistory,
  nextVerse,
  prevVerse,
  addNextVerseToSelection,
  removeVerseFromSelection,
  changeBible,
  nextPane,
  prevPane,
  addParallelPane,
  closeCurrentPane,
  movePaneToRight,
  movePaneToLeft,
  toggleMenubar,
  toggleFullscreen,
  switchDisplayMode,
  zoomIn,
  zoomOut,
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
  AppCommand.addNextVerseToSelection: AppCommandInfo(
    label: 'Add next verse to selection',
    description: 'Extend verse selection',
  ),
  AppCommand.removeVerseFromSelection: AppCommandInfo(
    label: 'Remove verse from selection',
    description: 'Reduce verse selection',
  ),
  AppCommand.addParallelPane: AppCommandInfo(
    label: 'Add Parallel Pane',
    description: 'Open a new pane alongside the current one.',
  ),
  AppCommand.closeCurrentPane: AppCommandInfo(
    label: 'Close Current Pane',
    description: 'Close the currently active pane.',
  ),
  AppCommand.toggleMenubar: AppCommandInfo(
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
  AppCommand.zoomIn: AppCommandInfo(
    label: 'Zoom In',
    description: 'Increase the zoom level of the current view.',
  ),
  AppCommand.zoomOut: AppCommandInfo(
    label: 'Zoom Out',
    description: 'Decrease the zoom level of the current view.',
  ),
  AppCommand.movePaneToRight: AppCommandInfo(
    label: 'Swap active pane with the next one',
    description: 'Swap the position of the active pane with the next one.',
  ),
  AppCommand.movePaneToLeft: AppCommandInfo(
    label: 'Swap active pane with the previous one',
    description: 'Swap the position of the active pane with the previous one.',
  ),
};
