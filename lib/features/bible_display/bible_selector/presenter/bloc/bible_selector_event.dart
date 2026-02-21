part of 'bible_selector_bloc.dart';

sealed class BibleSelectorEvent extends Equatable {
  const BibleSelectorEvent();

  @override
  List<Object> get props => [];
}

class BibleSelectorInit extends BibleSelectorEvent {
  const BibleSelectorInit();

  @override
  List<Object> get props => [];
}

class BibleSelectorSelect extends BibleSelectorEvent {
  final int selectedBibleId;

  const BibleSelectorSelect(this.selectedBibleId);

  @override
  List<Object> get props => [selectedBibleId];
}
