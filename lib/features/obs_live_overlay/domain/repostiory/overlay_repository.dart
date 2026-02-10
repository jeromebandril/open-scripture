import '../entities/overlay_models.dart';

abstract class OverlayRepository {
  OverlaySnapshot get snapshot;
  bool get isRunning;

  Future<void> start({int port = 17890, required String controllerToken});
  Future<void> stop();

  void setText({required OverlayId id, required String text});
  void setVisible({required OverlayId id, required bool visible});
  void setSnapshot({required OverlaySnapshot snapshot});
}
