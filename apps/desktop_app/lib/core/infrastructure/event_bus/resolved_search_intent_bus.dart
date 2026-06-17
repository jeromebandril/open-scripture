import 'dart:async';

import 'package:open_scripture/shared/domain/entities/bible_ref_partial.dart';

import '../../../shared/domain/entities/bible_ref.dart';

class ResolvedSearchIntentBus {
  final _controller = StreamController<ResolvedSearchIntent>.broadcast();

  Stream<ResolvedSearchIntent> get stream => _controller.stream;
  void emit(ResolvedSearchIntent intent) => _controller.add(intent);
  void dispose() => _controller.close();
}

sealed class ResolvedSearchIntent {}

class ResolvedRefIntent extends ResolvedSearchIntent {
  final BibleRef ref;
  final bool isVerseLevel;
  ResolvedRefIntent({required this.ref, required this.isVerseLevel});
}

class ResolvedPartialRefIntent extends ResolvedSearchIntent {
  final BibleRefPartial ref;
  ResolvedPartialRefIntent({required this.ref});
}

class ResolvedStringSearchIntent extends ResolvedSearchIntent {
  final List<BibleRef> results;
  ResolvedStringSearchIntent({required this.results});
}
