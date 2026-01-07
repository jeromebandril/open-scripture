part of 'bible_pane_bloc.dart';

sealed class BiblePaneEvent extends Equatable {
  const BiblePaneEvent();

  @override
  List<Object> get props => [];
}

class BiblePaneOpen extends BiblePaneEvent {
  final int bibleId;

  const BiblePaneOpen(this.bibleId);

  @override
  List<Object> get props => [bibleId];
}

class BiblePaneDisplayVerses extends BiblePaneEvent {
  final BibleRef ref;

  const BiblePaneDisplayVerses(this.ref);

  @override
  List<Object> get props => [ref];
}

class BiblePaneDisplayChapter extends BiblePaneEvent {
  final BibleRef ref;
  final bool withSpans;

  const BiblePaneDisplayChapter({
    required this.ref,
    required this.withSpans,
  });

  @override
  List<Object> get props => [ref, withSpans];
}
