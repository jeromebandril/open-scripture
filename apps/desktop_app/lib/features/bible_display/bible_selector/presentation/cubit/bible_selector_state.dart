part of 'bible_selector_cubit.dart';

final class BibleSelectorState extends Equatable {
  const BibleSelectorState({
    required this.selectedBiblesIds,
  });

  final List<BibleId> selectedBiblesIds;

  BibleRepositoryType? get activeRepoType =>
      selectedBiblesIds.isEmpty ? null : selectedBiblesIds.first.repoType;

  BibleSelectorState copyWith({
    BibleRepositoryType? repoType,
    List<BibleId>? selectedBiblesIds,
  }) {
    return BibleSelectorState(
      selectedBiblesIds: selectedBiblesIds ?? this.selectedBiblesIds,
    );
  }

  @override
  List<Object?> get props => [selectedBiblesIds];
}
