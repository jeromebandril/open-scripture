part of 'bible_selector_bloc.dart';

enum BibleSelectorStatus {
  inital,
  error,
  ready,
}

class BibleSelectorState extends Equatable {
  const BibleSelectorState({
    this.status = BibleSelectorStatus.inital,
    this.selectedBibleIds = const [],
    this.errorMessage,
  });

  final BibleSelectorStatus status;
  final List<int> selectedBibleIds;
  final String? errorMessage;

  BibleSelectorState copyWith({
    BibleSelectorStatus Function()? status,
    List<int> Function()? selectedBibleIds,
    String Function()? errorMessage,
  }) {
    return BibleSelectorState(
      status: status != null ? status() : this.status,
      selectedBibleIds:
          selectedBibleIds != null ? selectedBibleIds() : this.selectedBibleIds,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, selectedBibleIds, errorMessage];
}
