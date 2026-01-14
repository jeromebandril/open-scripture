import 'dart:async';

import '../../../../core/domain/entities/bible_ref.dart';

class NavigationFeedback {
  final BibleRef ref;
  final bool success;
  final String? error;

  const NavigationFeedback({
    required this.ref,
    required this.success,
    this.error,
  });
}

class NavigationBus {
  final _c = StreamController<NavigationFeedback>.broadcast();
  Stream<NavigationFeedback> get stream => _c.stream;
  void emit(NavigationFeedback e) => _c.add(e);
  Future<void> close() => _c.close();
}
