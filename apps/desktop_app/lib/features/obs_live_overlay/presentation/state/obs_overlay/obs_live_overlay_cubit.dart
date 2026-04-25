import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/obs_live_overlay/domain/repostiory/overlay_repository.dart';

import '../../../../../core/infrastructure/event_bus/selected_verse_bus.dart';
import '../../../domain/entities/overlay_models.dart';

part 'obs_live_overlay_state.dart';

class ObsLiveOverlayCubit extends Cubit<ObsLiveOverlayState> {
  ObsLiveOverlayCubit({
    required this.repo,
    required SelectedVerseBus notifier,
  }) : super(ObsLiveOverlayState.initial()) {
    _sub = notifier.stream.listen((snapshot) {
      if (!repo.isRunning) return;
      setSnapshot(snapshot);
    });
  }

  final OverlayRepository repo;
  late final StreamSubscription _sub;
  Timer? _hideDebounce;

  void _scheduleHideDeb() {
    _hideDebounce?.cancel();
    final emptySnapshot = OverlaySnapshot.initial();
    _hideDebounce =
        Timer(const Duration(seconds: 30), () => setSnapshot(emptySnapshot));
  }

  Future<void> startServer(int port) async {
    emit(state.copyWith(busy: true, error: null));
    try {
      await repo.start(port: port, controllerToken: '123456');
      emit(state.copyWith(
        busy: false,
        isRunning: repo.isRunning,
        snapshot: repo.snapshot,
      ));
    } catch (e) {
      emit(state.copyWith(
          busy: false, error: e.toString(), isRunning: repo.isRunning));
    }
  }

  Future<void> stopServer() async {
    emit(state.copyWith(busy: true, error: null));
    try {
      await repo.stop();
      emit(state.copyWith(
        busy: false,
        isRunning: repo.isRunning,
        snapshot: repo.snapshot,
      ));
    } catch (e) {
      emit(state.copyWith(
          busy: false, error: e.toString(), isRunning: repo.isRunning));
    }
  }

  void setSnapshot(OverlaySnapshot snapshot) {
    repo.setSnapshot(snapshot: snapshot);
    emit(state.copyWith(snapshot: repo.snapshot));
    _scheduleHideDeb();
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
