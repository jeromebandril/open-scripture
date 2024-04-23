part of 'split_viewer_bloc.dart';

enum SplitStatus {
  initial,
  error,
  success,
}

class SplitViewerState extends Equatable {
  const SplitViewerState({
    this.status = SplitStatus.initial,
    this.conf = const SplitConfiguration(),
  });

  final SplitStatus status;
  final SplitConfiguration conf;

  @override
  List<Object> get props => [status, conf];
}
