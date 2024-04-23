part of 'split_viewer_bloc.dart';

sealed class SplitViewerEvent extends Equatable {
  const SplitViewerEvent();

  @override
  List<Object> get props => [];
}

class SplitViewerHorizontally extends SplitViewerEvent {
  final SplitConfiguration conf;

  const SplitViewerHorizontally(this.conf);

  @override
  List<Object> get props => [conf];
}

class SplitViewerVertically extends SplitViewerEvent {
  final SplitConfiguration conf;

  const SplitViewerVertically(this.conf);

  @override
  List<Object> get props => [conf];
}
