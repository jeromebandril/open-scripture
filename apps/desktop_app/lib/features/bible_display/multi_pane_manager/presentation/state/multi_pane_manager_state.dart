part of 'multi_pane_manager_cubit.dart';

enum SplitStatus {
  initial,
  error,
  success,
}

class PaneManagerState extends Equatable {
  const PaneManagerState({
    this.status = SplitStatus.initial,
    required this.panes,
    required this.activePaneId,
  });

  final SplitStatus status;
  final List<PaneDescriptor> panes;
  final int activePaneId;

  @override
  List<Object?> get props => [status, panes, activePaneId];
}
