import 'dart:async';

import '../../../shared/domain/entities/bible_ref.dart';
import '../../../shared/domain/entities/verse.dart';

class SelectedVerseBus {
  final _c = StreamController<SelectedVerseBusItem>.broadcast();
  Stream<SelectedVerseBusItem> get stream => _c.stream;

  void update(SelectedVerseBusItem data) => _c.add(data);

  Future<void> close() => _c.close();
}

class SelectedVerseBusItem {
  final BibleRef ref;
  final List<Verse> verses;

  const SelectedVerseBusItem({required this.ref, required this.verses});
}
