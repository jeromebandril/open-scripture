import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/infrastructure/event_bus/selected_verse_bus.dart';
import '../../data/datasource/overlay_file_system.dart';
import '../../domain/entities/overlay_models.dart';
import '../../domain/repostiory/overlay_repository.dart';
import '../../domain/service/verse_html_formatter.dart';

part 'obs_live_overlay_state.dart';

class ObsLiveOverlayCubit extends Cubit<ObsLiveOverlayState> {
  ObsLiveOverlayCubit({
    required OverlayRepository repo,
    required OverlayFilesystem filesystem,
    required SelectedVerseBus selectedVerseBus,
    required VerseHtmlFormatter htmlFormatter,
  })  : _filesystem = filesystem,
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
  final OverlayFilesystem _filesystem;
  final VerseHtmlFormatter _htmlFormatter;
  late final StreamSubscription _sub;
  Timer? _hideDebounceTimer;

  Future<void> startServer() {
    return _run(() => _repo.start());
  }

  Future<void> stopServer() {
    _hideDebounceTimer?.cancel();
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
    _scheduleHideDeb();
  }

  Future<void> openAssetsFolder() async {
    final overlayDir = await _filesystem.getOverlayDir();

    final uri = Uri.directory(overlayDir.path);

    await launchUrl(uri);
  }

  Future<void> resetAssetsToDefaults() async =>
      await _filesystem.resetToDefaults();

  void _scheduleHideDeb() {
    _hideDebounceTimer?.cancel();
    _hideDebounceTimer = Timer(const Duration(seconds: 30),
        () => setSnapshot(OverlaySnapshot.initial()));
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
