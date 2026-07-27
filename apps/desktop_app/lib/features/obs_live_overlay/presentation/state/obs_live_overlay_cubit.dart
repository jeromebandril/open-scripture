import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/infrastructure/event_bus/selected_verse_bus.dart';
import '../../../../core/settings/settings_repository.dart';
import '../../domain/entities/overlay_models.dart';
import '../../domain/repostiory/overlay_repository.dart';
import '../../domain/service/verse_html_formatter.dart';
import '../../settings/overlay_settings.dart';

part 'obs_live_overlay_state.dart';

class ObsLiveOverlayCubit extends Cubit<ObsLiveOverlayState> {
  ObsLiveOverlayCubit({
    required OverlayRepository repo,
    required SelectedVerseBus selectedVerseBus,
    required VerseHtmlFormatter htmlFormatter,
    required SettingsRepository<OverlaySettings> settings,
  })  : _settings = settings,
        _htmlFormatter = htmlFormatter,
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
  final SettingsRepository<OverlaySettings> _settings;
  final VerseHtmlFormatter _htmlFormatter;
  late final StreamSubscription _sub;

  /// Timer that sends a snapshot
  /// to set the web page blank
  Timer? _setBlankTimer;

  Future<void> startServer() {
    return _run(() => _repo.start());
  }

  Future<void> stopServer() {
    _setBlankTimer?.cancel();
    return _run(() => _repo.stop());
  }

  Future<void> _run(Future<void> Function() action) async {
    emit(state.copyWith(busy: true, error: null));
    try {
      await action();
      emit(state.copyWith(
        busy: false,
        isRunning: _repo.isRunning,
        snapshot: _repo.snapshot,
      ));
    } catch (e) {
      emit(state.copyWith(
        busy: false,
        error: e.toString(),
        isRunning: _repo.isRunning,
      ));
    }
  }

  void setSnapshot(OverlaySnapshot snapshot) {
    _repo.setSnapshot(snapshot: snapshot);
    emit(state.copyWith(snapshot: _repo.snapshot));
    if (snapshot == OverlaySnapshot.initial()) return;
    _scheduleHideDeb();
  }

  Future<void> openAssetsFolder() async {
    final overlayDir = await _repo.getOverlayDirectory();
    final uri = Uri.directory(overlayDir.path);
    await launchUrl(uri);
  }

  Future<void> resetAssetsToDefaults() async =>
      await _repo.resetAssetsToDefault();

  void _scheduleHideDeb() {
    _setBlankTimer?.cancel();
    _setBlankTimer = Timer(
      Duration(seconds: _settings.current.hideDebounceSeconds),
      () => setSnapshot(OverlaySnapshot.initial()),
    );
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
