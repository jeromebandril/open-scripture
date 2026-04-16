part of 'b_searchbar_bloc.dart';

enum BSearchbarStatus {
  initial,
  error,
  success,
}

class BSearchbarState extends Equatable {
  const BSearchbarState({
    this.status = BSearchbarStatus.initial,
    this.referenceResult,
    this.results = const [],
    this.history = const [],
    this.intentType = BSearchIntentType.gotoReference,
    this.errorMessage,
  });

  final BSearchbarStatus status;

  /// Used only when intentType == gotoReference
  final BibleRef? referenceResult;

  /// Used only when intentType == keywordSearch (or similar)
  final List<BibleRef> results;
  final List<HistoryData> history;
  final BSearchIntentType intentType;
  final String? errorMessage;

  BSearchbarState copyWith({
    BSearchbarStatus Function()? status,
    BibleRef Function()? referenceResult,
    List<BibleRef> Function()? results,
    List<HistoryData> Function()? history,
    BSearchIntentType Function()? intentType,
    String? Function()? errorMessage,
  }) {
    return BSearchbarState(
      status: status != null ? status() : this.status,
      referenceResult:
          referenceResult != null ? referenceResult() : this.referenceResult,
      results: results != null ? results() : this.results,
      history: history != null ? history() : this.history,
      intentType: intentType != null ? intentType() : this.intentType,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        referenceResult,
        results,
        history,
        intentType,
        errorMessage,
      ];
}
