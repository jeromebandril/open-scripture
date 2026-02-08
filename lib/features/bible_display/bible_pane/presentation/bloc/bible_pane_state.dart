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
    this.bibleMeta,
    this.reference,
    this.segments = const [],
    this.isMixed = false,
    this.errorMessage,
    this.dMode = DisplayMode.normal,
    this.maxVerse,
  });

  final int paneId;
  final BiblePaneStatus status;
  final int? bibleId;
  final BibleMeta? bibleMeta;
  final BibleRef? reference;
  final List<VerseSegment> segments;
  final bool isMixed;
  final String? errorMessage;
  final DisplayMode dMode;
  final int? maxVerse;

  BiblePaneState copyWith({
    int Function()? paneId,
    int? Function()? bibleId,
    BibleMeta Function()? bibleMeta,
    BiblePaneStatus Function()? status,
    BibleRef Function()? reference,
    List<VerseSegment> Function()? segments,
    bool Function()? isMixed,
    String? Function()? errorMessage,
    DisplayMode Function()? dMode,
    int? Function()? maxVerse,
  }) {
    return BiblePaneState(
      bibleId: bibleId != null ? bibleId() : this.bibleId,
      bibleMeta: bibleMeta != null ? bibleMeta() : this.bibleMeta,
      status: status != null ? status() : this.status,
      reference: reference != null ? reference() : this.reference,
      segments: segments != null ? segments() : this.segments,
      paneId: paneId != null ? paneId() : this.paneId,
      isMixed: isMixed != null ? isMixed() : this.isMixed,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      dMode: dMode != null ? dMode() : this.dMode,
      maxVerse: maxVerse != null ? maxVerse() : this.maxVerse,
    );
  }

  @override
  List<Object?> get props => [
        paneId,
        status,
        bibleId,
        bibleMeta,
        reference,
        segments,
        isMixed,
        errorMessage,
        dMode,
        maxVerse,
      ];
}
