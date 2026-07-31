part of 'bible_pane_bloc.dart';

enum BiblePaneStatus {
  selectBibles,
  loading,
  ready,
  error,
}

class BiblePaneState extends Equatable {
  const BiblePaneState._({
    required this.paneId,
    required this.status,
    required this.reference,
    required this.content,
    required this.parallelOrder,
    required this.isNotSameBookChapter,
    required this.errorMessage,
    required this.dMode,
    required this.verseCount,
    required this.repoType,
    this.selectedWord,
  });

  factory BiblePaneState({
    required int paneId,
    ParallelBibleConfig content = ParallelBibleConfig.empty,
    List<BibleId> parallelOrder = const [],
    BiblePaneStatus status = BiblePaneStatus.selectBibles,
    BibleRef? reference,
    bool isMixed = false,
    String? errorMessage,
    required DisplayMode dMode,
    int? verseCount,
    BibleRepositoryType repoType = BibleRepositoryType.localDatabase,
    WordInfo? selectedWord,
  }) {
    return BiblePaneState._(
      paneId: paneId,
      status: status,
      reference: reference,
      content: content,
      parallelOrder: parallelOrder,
      isNotSameBookChapter: isMixed,
      errorMessage: errorMessage,
      dMode: dMode,
      verseCount: verseCount,
      repoType: repoType,
      selectedWord: selectedWord,
    );
  }

  final int paneId;
  final BiblePaneStatus status;
  final BibleRef? reference;
  final ParallelBibleConfig content;
  final List<BibleId> parallelOrder;
  final bool isNotSameBookChapter;
  final String? errorMessage;
  final DisplayMode dMode;
  final int? verseCount;
  final BibleRepositoryType repoType;
  final WordInfo? selectedWord;

  SplayTreeSet<BibleRef> get unionRefs =>
      content.computeUnion(preserveOrder: isNotSameBookChapter);

  List<BibleId> get openedBiblesIds => content.keys.toList();

  BiblePaneState copyWith({
    int Function()? paneId,
    BiblePaneStatus Function()? status,
    BibleRef Function()? reference,
    ParallelBibleConfig Function()? content,
    List<BibleId> Function()? parallelOrder,
    bool Function()? isNotSameBookChapter,
    String? Function()? errorMessage,
    DisplayMode Function()? dMode,
    int? Function()? verseCount,
    BibleRepositoryType Function()? repoType,
    WordInfo? Function()? selectedWord,
  }) {
    return BiblePaneState(
      paneId: paneId != null ? paneId() : this.paneId,
      status: status != null ? status() : this.status,
      reference: reference != null ? reference() : this.reference,
      content: content != null ? content() : this.content,
      parallelOrder:
          parallelOrder != null ? parallelOrder() : this.parallelOrder,
      isMixed: isNotSameBookChapter != null
          ? isNotSameBookChapter()
          : this.isNotSameBookChapter,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      dMode: dMode != null ? dMode() : this.dMode,
      verseCount: verseCount != null ? verseCount() : this.verseCount,
      repoType: repoType != null ? repoType() : this.repoType,
      selectedWord: selectedWord != null ? selectedWord() : this.selectedWord,
    );
  }

  @override
  List<Object?> get props => [
        paneId,
        status,
        reference,
        content,
        parallelOrder,
        isNotSameBookChapter,
        errorMessage,
        dMode,
        verseCount,
        repoType,
        selectedWord,
      ];
}
