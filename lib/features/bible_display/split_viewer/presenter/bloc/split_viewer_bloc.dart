import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_viewer/domain/entities/split_configuration.dart';

part 'split_viewer_event.dart';
part 'split_viewer_state.dart';

class SplitViewerBloc extends Bloc<SplitViewerEvent, SplitViewerState> {
  SplitViewerBloc() : super(const SplitViewerState()) {
    on<SplitViewerHorizontally>(_onSplitHorizontally);
    on<SplitViewerVertically>(_onSplitVertically);
  }

  Future<void> _onSplitHorizontally(
    SplitViewerHorizontally event,
    Emitter<SplitViewerState> emit,
  ) async {}

  Future<void> _onSplitVertically(
    SplitViewerVertically event,
    Emitter<SplitViewerState> emit,
  ) async {}
}
