import '../../domain/entities/overlay_models.dart';
import '../../domain/repostiory/overlay_repository.dart';
import '../datasource/overlay_control_server.dart';

class OverlayRepositoryImpl implements OverlayRepository {
  final OverlayControlServer server;

  OverlayRepositoryImpl({required this.server});

  @override
  bool get isRunning => server.isRunning;

  @override
  Future<void> start({required int port, required String controllerToken}) =>
      server.start(port: port, controllerToken: controllerToken);

  @override
  Future<void> stop() async {
    if (isRunning) {
      server.setSnapshot(OverlaySnapshot.initial());
      server.broadcastState();
    }
    await server.stop();
  }

  @override
  OverlaySnapshot get snapshot =>
      isRunning ? server.snapshot : OverlaySnapshot.initial();

  @override
  void setProperty({required OverlayId id, String? text, bool? visible}) {
    OverlayItem? overlayItem = snapshot.items[id];
    if (overlayItem == null) return;

    overlayItem = overlayItem.copyWith(
      text: text ?? overlayItem.text,
      visible: visible ?? overlayItem.visible,
    );
    server.setSnapshot(snapshot.copyWithItem(id, overlayItem));
    server.broadcastState();
  }

  @override
  void setSnapshot({required OverlaySnapshot snapshot}) {
    if (!isRunning) return;
    server.setSnapshot(snapshot);
    server.broadcastState();
  }
}
