part of 'bible_selector_bloc.dart';

enum BibleSelectorStatus {
  inital,
  error,
  ready,
}

class BibleSelectorState extends Equatable {
  const BibleSelectorState({
    this.status = BibleSelectorStatus.inital,
    this.selectedBibleId,
    this.errorMessage,
  });

  final BibleSelectorStatus status;
  final int? selectedBibleId;
  final String? errorMessage;

  BibleSelectorState copyWith({
    BibleSelectorStatus Function()? status,
    int Function()? selectedBibleId,
    String Function()? errorMessage,
  }) {
    return BibleSelectorState(
      status: status != null ? status() : this.status,
      selectedBibleId:
          selectedBibleId != null ? selectedBibleId() : this.selectedBibleId,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, selectedBibleId, errorMessage];
}
