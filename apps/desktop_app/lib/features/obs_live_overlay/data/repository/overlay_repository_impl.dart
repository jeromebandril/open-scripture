import 'dart:async';
import 'dart:io';

import '../../../../core/settings/settings_repository.dart';
import '../../domain/entities/overlay_models.dart';
import '../../domain/repostiory/overlay_repository.dart';
import '../../settings/overlay_settings.dart';
import '../datasource/overlay_control_server.dart';
import '../datasource/overlay_file_system.dart';

class OverlayRepositoryImpl implements OverlayRepository {
  final OverlayControlServer _server;
  final SettingsRepository<OverlaySettings> _settings;
  final OverlayFilesystem _filesystem;

  OverlayRepositoryImpl({
    required OverlayControlServer server,
    required SettingsRepository<OverlaySettings> settings,
    required OverlayFilesystem filesystem,
  })  : _server = server,
        _settings = settings,
        _filesystem = filesystem;

  @override
  bool get isRunning => _server.isRunning;

  @override
  Future<void> start() => _server.start(port: _settings.current.port);

  @override
  Future<void> stop() async {
    if (isRunning) {
      _server.setSnapshot(OverlaySnapshot.initial());
      _server.broadcastState();
    }
    await _server.stop();
  }

  @override
  OverlaySnapshot get snapshot =>
      isRunning ? _server.snapshot : OverlaySnapshot.initial();

  @override
  void setProperty({required OverlayId id, String? text, bool? visible}) {
    OverlayItem? overlayItem = snapshot.items[id];
    if (overlayItem == null) return;

    overlayItem = overlayItem.copyWith(
      text: text ?? overlayItem.text,
      visible: visible ?? overlayItem.visible,
    );
    _server.setSnapshot(snapshot.copyWithItem(id, overlayItem));
    _server.broadcastState();
  }

  @override
  void setSnapshot({required OverlaySnapshot snapshot}) {
    if (!isRunning) return;
    _server.setSnapshot(snapshot);
    _server.broadcastState();
  }

  @override
  Future<Directory> getOverlayDirectory() async =>
      await _filesystem.getOverlayDir();

  @override
  Future<void> resetAssetsToDefault() async =>
      await _filesystem.resetToDefaults();
}
