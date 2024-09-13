import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/bible_reference.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/domain/entities/split_configuration.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/domain/usecases/split_horizontally.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/domain/usecases/split_vertically.dart';

part 'split_screen_event.dart';
part 'split_screen_state.dart';

class SplitScreenBloc extends Bloc<SplitScreenEvent, SplitScreenState> {
  SplitHorizontally splitX;
  SplitVertically splitY;

  SplitScreenBloc({
    required this.splitX,
    required this.splitY,
  }) : super(const SplitScreenState()) {
    on<SplitScreenSubscriptionRequested>(_onSubscriptionRequested);
    on<SplitScreenX>(_onSplitHorizontally);
    on<SplitScreenY>(_onSplitVertically);
    on<SplitScreenMoveFocus>(_onMoveFocus);
    on<SplitScreenSendSignal>(_onSendSignal);
  }

  Future<void> _onSubscriptionRequested(
    SplitScreenSubscriptionRequested event,
    Emitter<SplitScreenState> emit,
  ) async {}

  Future<void> _onSplitHorizontally(
    SplitScreenX event,
    Emitter<SplitScreenState> emit,
  ) async {
    final eitherSuccessOrFailure = await splitX(state.conf);
    eitherSuccessOrFailure.fold(
      (fail) => print("> Splitview: failed to horizontal split"),
      (newConf) => emit(state.copyWith(
        conf: () => newConf,
        focusedId: () => newConf.horizontal.length,
      )),
    );
  }

  Future<void> _onSplitVertically(
    SplitScreenY event,
    Emitter<SplitScreenState> emit,
  ) async {
    final eitherSuccessOrFailure = await splitY(state.conf);
    eitherSuccessOrFailure.fold(
      (fail) => print("> Splitview: failed to vertical split"),
      (newConf) => emit(state.copyWith(conf: () => newConf)),
    );
  }

  Future<void> _onMoveFocus(
    SplitScreenMoveFocus event,
    Emitter<SplitScreenState> emit,
  ) async {
    if (event.id != null) {
      print("asdifjiasdjfijd");
      emit(state.copyWith(focusedId: () => event.id!));
      return;
    }
    if (event.direction == null) return;

    switch (event.direction) {
      case "RIGHT":
        emit(state.copyWith(focusedId: () => state.focusedId + 1));
        break;
      case "LEFT":
        emit(state.copyWith(focusedId: () => state.focusedId - 1));
        break;
      default:
    }
  }

  Future<void> _onSendSignal(
    SplitScreenSendSignal event,
    Emitter<SplitScreenState> emit,
  ) async {
    return emit(state.copyWith(
      signalData: () => event.data,
      status: () => SplitStatus.success,
    ));
  }
}
