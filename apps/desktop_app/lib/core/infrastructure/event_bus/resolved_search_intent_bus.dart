import 'dart:async';

import '../../../shared/entities/bible_ref.dart';

class ResolvedSearchIntentBus {
  final _controller = StreamController<ResolvedSearchIntent>.broadcast();

  Stream<ResolvedSearchIntent> get stream => _controller.stream;
  void emit(ResolvedSearchIntent intent) => _controller.add(intent);
  void dispose() => _controller.close();
}

sealed class ResolvedSearchIntent {}

class ResolvedReferenceIntent extends ResolvedSearchIntent {
  final BibleRef ref;
  final bool isVerseLevel;
  ResolvedReferenceIntent({required this.ref, required this.isVerseLevel});
}

class ResolvedStringSearchIntent extends ResolvedSearchIntent {
  final List<BibleRef> results;
  ResolvedStringSearchIntent({required this.results});
}
