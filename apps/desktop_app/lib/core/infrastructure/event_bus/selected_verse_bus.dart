import '../../../shared/domain/entities/bible_ref.dart';
import '../../../shared/domain/entities/verse.dart';
import 'event_bus.dart';

class SelectedVerseBus extends EventBus<SelectedVerseBusItem> {
  void update(SelectedVerseBusItem data) {
    emit(data);
  }
}

class SelectedVerseBusItem {
  final BibleRef ref;
  final List<Verse> verses;

  const SelectedVerseBusItem({required this.ref, required this.verses});
}
