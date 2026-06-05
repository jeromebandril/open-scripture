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
    required SplayTreeSet<BibleRef> unionRefs,
    required this.isMixed,
    required this.errorMessage,
    required this.dMode,
    required this.verseCount,
    required this.repoType,
  }) : _unionRefs = unionRefs;

  factory BiblePaneState({
    required int paneId,
    ParallelBibleConfig content = ParallelBibleConfig.empty,
    List<BibleId> parallelOrder = const [],
    BiblePaneStatus status = BiblePaneStatus.selectBibles,
    BibleRef? reference,
    bool isMixed = false,
    String? errorMessage,
    DisplayMode dMode = DisplayMode.list,
    int? verseCount,
    BibleRepositoryType repoType = BibleRepositoryType.intalled,
  }) {
    return BiblePaneState._(
      paneId: paneId,
      status: status,
      reference: reference,
      content: content,
      parallelOrder: parallelOrder,
      unionRefs: content.computeUnion(),
      isMixed: isMixed,
      errorMessage: errorMessage,
      dMode: dMode,
      verseCount: verseCount,
      repoType: repoType,
    );
  }

  final int paneId;
  final BiblePaneStatus status;
  final BibleRef? reference;
  final ParallelBibleConfig content;
  final List<BibleId> parallelOrder;
  final bool isMixed;
  final String? errorMessage;
  final DisplayMode dMode;
  final int? verseCount;
  final BibleRepositoryType repoType;

  final SplayTreeSet<BibleRef> _unionRefs;
  SplayTreeSet<BibleRef> get unionRefs => SplayTreeSet.of(_unionRefs);

  List<BibleId> get openedBiblesIds => content.keys.toList();

  BiblePaneState copyWith({
    int Function()? paneId,
    BiblePaneStatus Function()? status,
    BibleRef Function()? reference,
    ParallelBibleConfig Function()? content,
    List<BibleId> Function()? parallelOrder,
    bool Function()? isMixed,
    String? Function()? errorMessage,
    DisplayMode Function()? dMode,
    int? Function()? verseCount,
    BibleRepositoryType Function()? repoType,
  }) {
    return BiblePaneState(
      paneId: paneId != null ? paneId() : this.paneId,
      status: status != null ? status() : this.status,
      reference: reference != null ? reference() : this.reference,
      content: content != null ? content() : this.content,
      parallelOrder:
          parallelOrder != null ? parallelOrder() : this.parallelOrder,
      isMixed: isMixed != null ? isMixed() : this.isMixed,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      dMode: dMode != null ? dMode() : this.dMode,
      verseCount: verseCount != null ? verseCount() : this.verseCount,
      repoType: repoType != null ? repoType() : this.repoType,
    );
  }

  @override
  List<Object?> get props => [
        paneId,
        status,
        reference,
        content,
        parallelOrder,
        isMixed,
        errorMessage,
        dMode,
        verseCount,
        repoType,
      ];
}
