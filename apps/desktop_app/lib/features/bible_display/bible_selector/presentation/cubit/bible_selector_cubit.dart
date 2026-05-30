import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';

part 'bible_selector_state.dart';

class BibleSelectorCubit extends Cubit<BibleSelectorState> {
  BibleSelectorCubit() : super(BibleSelectorState());

  void select(BibleId bibleId) {
    final currentIds = List<BibleId>.from(state.selectedBiblesIds);

    if (currentIds.contains(bibleId)) {
      currentIds.remove(bibleId);
    } else {
      currentIds.add(bibleId);
    }

    // 4. Emit the brand new list
    emit(BibleSelectorState(selectedBiblesIds: currentIds));
  }

  void set(List<BibleId> selected) =>
      emit(BibleSelectorState(selectedBiblesIds: selected));
}
