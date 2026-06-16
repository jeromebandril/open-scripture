import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/shared/domain/entities/bible_id.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';

part 'bible_selector_state.dart';

class BibleSelectorCubit extends Cubit<BibleSelectorState> {
  BibleSelectorCubit({
    List<BibleId> selectedBiblesIds = const [],
    BibleRepositoryType repoType = BibleRepositoryType.localDatabase,
  }) : super(
          BibleSelectorState(selectedBiblesIds: selectedBiblesIds),
        );

  void select(BibleId bibleId) {
    final current = List<BibleId>.from(state.selectedBiblesIds);

    // Deselect if already selected
    if (current.any((b) => b == bibleId)) {
      current.removeWhere((b) => b == bibleId);
      emit(BibleSelectorState(selectedBiblesIds: current));
      return;
    }

    // Different source: clear and start fresh with this one
    if (state.activeRepoType != null &&
        bibleId.repoType != state.activeRepoType) {
      emit(BibleSelectorState(selectedBiblesIds: [bibleId]));
      return;
    }

    current.add(bibleId);
    emit(BibleSelectorState(selectedBiblesIds: current));
  }

  void setSelected(List<BibleId> selected) =>
      emit(state.copyWith(selectedBiblesIds: selected));
}
