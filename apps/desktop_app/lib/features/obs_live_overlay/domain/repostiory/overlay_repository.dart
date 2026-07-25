import 'dart:io';

import '../entities/overlay_models.dart';

abstract class OverlayRepository {
  OverlaySnapshot get snapshot;
  bool get isRunning;

  Future<void> start();
  Future<void> stop();

  void setProperty({required OverlayId id, String? text, bool? visible});
  void setSnapshot({required OverlaySnapshot snapshot});
  Future<void> resetAssetsToDefault();
  Future<Directory> getOverlayDirectory();
}
