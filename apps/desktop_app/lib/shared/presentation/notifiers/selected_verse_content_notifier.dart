import 'dart:async';

import 'package:open_scripture/features/obs_live_overlay/domain/entities/overlay_models.dart';

class ContentOfSelectedVerseNotifier {
  final _c = StreamController<OverlaySnapshot>.broadcast();
  Stream<OverlaySnapshot> get stream => _c.stream;

  void update(OverlaySnapshot snapshot) => _c.add(snapshot);

  Future<void> close() => _c.close();
}
