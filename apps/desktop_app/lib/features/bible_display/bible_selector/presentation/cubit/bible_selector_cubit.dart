import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';

part 'bible_selector_state.dart';

class BibleSelectorCubit extends Cubit<BibleSelectorState> {
  BibleSelectorCubit({
    List<BibleId> selectedBiblesIds = const [],
    BibleRepositoryType repoType = BibleRepositoryType.installed,
  }) : super(
          BibleSelectorState(
            selectedBiblesIds: selectedBiblesIds,
            repoType: repoType,
          ),
        );

  void select(BibleId bibleId) {
    final currentIds = List<BibleId>.from(state.selectedBiblesIds);

    if (currentIds.contains(bibleId)) {
      currentIds.remove(bibleId);
    } else {
      currentIds.add(bibleId);
    }

    // 4. Emit the brand new list
    emit(state.copyWith(selectedBiblesIds: currentIds));
  }

  void setSelected(List<BibleId> selected) =>
      emit(state.copyWith(selectedBiblesIds: selected));

  void setRepoType(BibleRepositoryType repoType) =>
      emit(state.copyWith(repoType: repoType, selectedBiblesIds: []));
}
