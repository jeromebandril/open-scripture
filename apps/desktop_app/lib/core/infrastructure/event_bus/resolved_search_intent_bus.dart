import '../../../shared/domain/entities/bible_ref.dart';
import '../../../shared/domain/entities/bible_ref_partial.dart';
import 'event_bus.dart';

class ResolvedSearchIntentBus extends EventBus<ResolvedSearchIntent> {}

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

class ResolvedPartialMultipleRefIntent extends ResolvedSearchIntent {
  final List<BibleRefPartial> refs;
  ResolvedPartialMultipleRefIntent({required this.refs});
}

class ResolvedStringSearchIntent extends ResolvedSearchIntent {
  final List<BibleRef> results;
  ResolvedStringSearchIntent({required this.results});
}
