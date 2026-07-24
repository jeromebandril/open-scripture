import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/infrastructure/event_bus/selected_verse_bus.dart';
import '../../domain/entities/overlay_models.dart';
import '../../domain/repostiory/overlay_repository.dart';
import '../../domain/service/verse_html_formatter.dart';

part 'obs_live_overlay_state.dart';

class ObsLiveOverlayCubit extends Cubit<ObsLiveOverlayState> {
  ObsLiveOverlayCubit({
    required OverlayRepository repo,
    required SelectedVerseBus selectedVerseBus,
    required VerseHtmlFormatter htmlFormatter,
  })  : _htmlFormatter = htmlFormatter,
        _repo = repo,
        super(ObsLiveOverlayState.initial()) {
    _sub = selectedVerseBus.stream.listen((data) {
      if (!_repo.isRunning) return;

      final spans = data.verses.expand((v) => v.spans).toList();
      final verseHtml = _htmlFormatter.toHtml(spans);

      final snapshot = OverlaySnapshot(items: {
        'ref': OverlayItem(text: data.ref.toDisplayString(), visible: true),
        'content': OverlayItem(text: verseHtml, visible: true)
      });

      setSnapshot(snapshot);
    });
  }

  final OverlayRepository _repo;
  final VerseHtmlFormatter _htmlFormatter;
  late final StreamSubscription _sub;
  Timer? _hideDebounceTimer;
  int? _hideDebounceSeconds;

  void _setEmptySnapshot() {
    final emptySnapshot = OverlaySnapshot.initial();
    setSnapshot(emptySnapshot);
  }

  void _scheduleHideDeb() {
    _hideDebounceTimer?.cancel();
    _hideDebounceTimer = Timer(Duration(seconds: _hideDebounceSeconds ?? 30),
        () => _setEmptySnapshot());
  }

  Future<void> startServer({
    required int port,
    int? hideDebounceTimeSeconds,
  }) async {
    emit(state.copyWith(busy: true, error: null));
    try {
      await _repo.start(port: port, controllerToken: '123456');
      _hideDebounceSeconds = hideDebounceTimeSeconds;
      emit(state.copyWith(
        busy: false,
        isRunning: _repo.isRunning,
        snapshot: _repo.snapshot,
      ));
    } catch (e) {
      emit(state.copyWith(
          busy: false, error: e.toString(), isRunning: _repo.isRunning));
    }
  }

  Future<void> stopServer() async {
    emit(state.copyWith(busy: true, error: null));
    try {
      _hideDebounceTimer?.cancel();
      await _repo.stop();
      emit(state.copyWith(
        busy: false,
        isRunning: _repo.isRunning,
        snapshot: _repo.snapshot,
      ));
    } catch (e) {
      emit(state.copyWith(
          busy: false, error: e.toString(), isRunning: _repo.isRunning));
    }
  }

  void setSnapshot(OverlaySnapshot snapshot) {
    _repo.setSnapshot(snapshot: snapshot);
    emit(state.copyWith(snapshot: _repo.snapshot));
    _scheduleHideDeb();
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
