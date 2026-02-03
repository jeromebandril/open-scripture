part of 'bible_pane_bloc.dart';

sealed class BiblePaneEvent extends Equatable {
  const BiblePaneEvent();

  @override
  List<Object?> get props => [];
}

class BiblePaneOpen extends BiblePaneEvent {
  final int bibleId;

  const BiblePaneOpen(this.bibleId);

  @override
  List<Object> get props => [bibleId];
}

class BiblePaneDisplayVerses extends BiblePaneEvent {
  final List<BibleRef> refs;

  const BiblePaneDisplayVerses(this.refs);

  @override
  List<Object> get props => [refs];
}

class BiblePaneDisplayChapter extends BiblePaneEvent {
  final BibleRef ref;
  final bool withSpans;
  final IntentSource? source;

  const BiblePaneDisplayChapter({
    required this.ref,
    this.withSpans = true,
    this.source,
  });

  @override
  List<Object?> get props => [ref, withSpans, source];
}

class BiblePaneJustChangeRef extends BiblePaneEvent {
  final BibleRef ref;
  final bool saveHistory;
  final IntentSource? source;

  const BiblePaneJustChangeRef({
    required this.ref,
    this.saveHistory = false,
    this.source,
  });

  @override
  List<Object?> get props => [ref, saveHistory, source];
}

class BiblePaneCloseBible extends BiblePaneEvent {
  const BiblePaneCloseBible();
}

class BiblePaneSetDisplayMode extends BiblePaneEvent {
  final DisplayMode dMode;

  const BiblePaneSetDisplayMode(this.dMode);
}
