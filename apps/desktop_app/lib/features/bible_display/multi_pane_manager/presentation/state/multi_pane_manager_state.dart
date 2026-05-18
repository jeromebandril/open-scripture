part of 'multi_pane_manager_cubit.dart';

enum SplitStatus {
  initial,
  error,
  success,
}

const _unset = Object();

class PaneManagerState extends Equatable {
  const PaneManagerState({
    this.status = SplitStatus.initial,
    required this.panes,
    required this.activePaneId,
    this.removingPaneId,
  });

  final SplitStatus status;
  final List<PaneDescriptor> panes;
  final int activePaneId;
  final int? removingPaneId;

  PaneManagerState copyWith({
    List<PaneDescriptor>? panes,
    int? activePaneId,
    Object? removingPaneId = _unset,
  }) {
    return PaneManagerState(
      panes: panes ?? this.panes,
      activePaneId: activePaneId ?? this.activePaneId,
      removingPaneId: removingPaneId == _unset
          ? this.removingPaneId
          : removingPaneId as int?,
    );
  }

  @override
  List<Object?> get props => [status, panes, activePaneId, removingPaneId];
}
