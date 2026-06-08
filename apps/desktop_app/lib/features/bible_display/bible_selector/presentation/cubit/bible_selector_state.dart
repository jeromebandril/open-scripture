part of 'bible_selector_cubit.dart';

final class BibleSelectorState extends Equatable {
  const BibleSelectorState({
    required this.selectedBiblesIds,
    required this.repoType,
  });

  final BibleRepositoryType repoType;
  final List<BibleId> selectedBiblesIds;

  BibleSelectorState copyWith({
    BibleRepositoryType? repoType,
    List<BibleId>? selectedBiblesIds,
  }) {
    return BibleSelectorState(
      repoType: repoType ?? this.repoType,
      selectedBiblesIds: selectedBiblesIds ?? this.selectedBiblesIds,
    );
  }

  @override
  List<Object?> get props => [repoType, selectedBiblesIds];
}
