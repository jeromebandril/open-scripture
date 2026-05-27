import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bible_selector_state.dart';

class BibleSelectorCubit extends Cubit<BibleSelectorState> {
  BibleSelectorCubit() : super(BibleSelectorState());

  void select(int bibleId) {
    final currentIds = List<int>.from(state.selectedBiblesIds);

    if (currentIds.contains(bibleId)) {
      currentIds.remove(bibleId);
    } else {
      currentIds.add(bibleId);
    }

    // 4. Emit the brand new list
    emit(BibleSelectorState(selectedBiblesIds: currentIds));
  }

  void set(List<int> selected) =>
      emit(BibleSelectorState(selectedBiblesIds: selected));
}
