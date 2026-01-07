part of 'bible_pane_bloc.dart';

enum BiblePaneStatus {
  initial,
  loading,
  ready,
  error,
}

class BiblePaneState extends Equatable {
  const BiblePaneState({
    required this.paneId,
    this.status = BiblePaneStatus.initial,
    this.bibleId,
    this.reference,
    this.segments = const [],
    this.errorMessage,
  });

  final int paneId;
  final BiblePaneStatus status;
  final int? bibleId;
  final BibleRef? reference;
  final List<VerseSegment> segments;
  final String? errorMessage;

  BiblePaneState copyWith({
    int Function()? paneId,
    int Function()? bibleId,
    BiblePaneStatus Function()? status,
    BibleRef Function()? reference,
    List<VerseSegment> Function()? verseSegments,
    String? Function()? errorMessage,
  }) {
    return BiblePaneState(
      bibleId: bibleId != null ? bibleId() : this.bibleId,
      status: status != null ? status() : this.status,
      reference: reference != null ? reference() : this.reference,
      segments: verseSegments != null ? verseSegments() : this.segments,
      paneId: paneId != null ? paneId() : this.paneId,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        paneId,
        status,
        bibleId,
        reference,
        segments,
        errorMessage,
      ];
}
