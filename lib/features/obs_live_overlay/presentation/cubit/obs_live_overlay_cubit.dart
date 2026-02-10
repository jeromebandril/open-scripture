import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/obs_live_overlay/domain/repostiory/overlay_repository.dart';

import '../../../../shared/presentation/notifiers/selected_verse_content_notifier.dart';
import '../../domain/entities/overlay_models.dart';

part 'obs_live_overaly_state.dart';

class ObsLiveOverlayCubit extends Cubit<ObsLiveOverlayState> {
  ObsLiveOverlayCubit({
    required this.repo,
    required ContentOfSelectedVerseNotifier notifier,
  }) : super(ObsLiveOverlayState.initial()) {
    _sub = notifier.stream.listen((snapshot) {
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

  Future<void> startServer() async {
    emit(state.copyWith(busy: true, error: null));
    try {
      await repo.start(port: 17890, controllerToken: '123456');
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
