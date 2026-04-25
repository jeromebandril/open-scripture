import 'dart:async';

import '../../../shared/entities/bible_ref.dart';

enum IntentSource { searchbar }

class NavigationFeedback {
  final BibleRef ref;
  final bool success;
  final String? error;
  final IntentSource? source;

  const NavigationFeedback({
    required this.ref,
    required this.success,
    this.error,
    this.source,
  });
}

class NavigationBus {
  final _c = StreamController<NavigationFeedback>.broadcast();
  Stream<NavigationFeedback> get stream => _c.stream;
  void emit(NavigationFeedback e) => _c.add(e);
  Future<void> close() => _c.close();
}
