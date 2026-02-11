import 'package:open_scripture/features/obs_live_overlay/data/datasource/overlay_control_server.dart';
import 'package:open_scripture/features/obs_live_overlay/domain/repostiory/overlay_repository.dart';

import '../../domain/entities/overlay_models.dart';
import '../datasource/overlay_server_manager.dart';

class OverlayRepositoryImpl implements OverlayRepository {
  final OverlayServerManager mgr;

  OverlayRepositoryImpl({required this.mgr});

  @override
  bool get isRunning => mgr.isRunning;

  @override
  Future<void> start({int port = 17890, required String controllerToken}) {
    return mgr.start(port: port, controllerToken: controllerToken);
  }

  @override
  Future<void> stop() {
    if (isRunning) {
      final hidden = OverlaySnapshot.initial();
      _requireServer().setSnapshot(hidden);
    }
    return mgr.stop();
  }

  OverlayControlServer _requireServer() => mgr.server;

  @override
  OverlaySnapshot get snapshot {
    if (!isRunning) return OverlaySnapshot.initial();
    return _requireServer().snapshot;
  }

  @override
  void setText({required OverlayId id, required String text}) {
    final s = _requireServer();

    final snap = s.snapshot;
    final existing =
        snap.items[id] ?? const OverlayItem(text: '', visible: true);
    s.setSnapshot(snap.copyWithItem(id, existing.copyWith(text: text)));
    s.broadcastState();
  }

  @override
  void setVisible({required OverlayId id, required bool visible}) {
    final s = _requireServer();

    final snap = s.snapshot;
    final existing =
        snap.items[id] ?? const OverlayItem(text: '', visible: true);
    s.setSnapshot(snap.copyWithItem(id, existing.copyWith(visible: visible)));
    s.broadcastState();
  }

  @override
  void setSnapshot({required OverlaySnapshot snapshot}) {
    final s = _requireServer();
    s.setSnapshot(snapshot);
    s.broadcastState();
  }
}
