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
  });

  final BSearchbarStatus status;
  final BibleReference? referenceResult;

  BSearchbarState copyWith({
    BSearchbarStatus Function()? status,
    BibleReference Function()? referenceResult,
  }) {
    return BSearchbarState(
      status: status != null ? status() : this.status,
      referenceResult:
          referenceResult != null ? referenceResult() : this.referenceResult,
    );
  }

  @override
  List<Object?> get props => [status, referenceResult];
}
