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
    this.history = const [],
    this.intentType = BSearchIntentType.gotoReference,
  });

  final BSearchbarStatus status;
  final BibleRef? referenceResult;
  final List<BibleRef> history;
  final BSearchIntentType intentType;

  BSearchbarState copyWith({
    BSearchbarStatus Function()? status,
    BibleRef Function()? referenceResult,
    List<BibleRef> Function()? history,
    BSearchIntentType Function()? intentType,
  }) {
    return BSearchbarState(
      status: status != null ? status() : this.status,
      referenceResult:
          referenceResult != null ? referenceResult() : this.referenceResult,
      history: history != null ? history() : this.history,
      intentType: intentType != null ? intentType() : this.intentType,
    );
  }

  @override
  List<Object?> get props => [status, referenceResult, history, intentType];
}
