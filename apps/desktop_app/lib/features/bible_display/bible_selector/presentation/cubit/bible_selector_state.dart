part of 'bible_selector_cubit.dart';

final class BibleSelectorState extends Equatable {
  const BibleSelectorState({this.selectedBiblesIds = const []});

  final List<int> selectedBiblesIds;

  @override
  List<Object?> get props => [selectedBiblesIds];
}
