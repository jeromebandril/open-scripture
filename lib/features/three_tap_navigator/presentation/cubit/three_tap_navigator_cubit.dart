import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';
import 'package:open_scripture/features/three_tap_navigator/domain/repository/three_tap_navigator_repository.dart';

import '../../../../shared/domain/entities/book.dart';

part 'three_tap_navigator_state.dart';

class ThreeTapNavigatorCubit extends Cubit<ThreeTapNavigatorState> {
  ThreeTapNavigatorCubit({required ThreeTapNavigatorRepository repo})
      : _repo = repo,
        super(ThreeTapNavigatorState());

  int? _bibleId;
  final ThreeTapNavigatorRepository _repo;
  final Map<int, int> _selectedBookIds = {};
  final Map<String, int> _selectedChapterIds = {};

  Future<void> loadBooks(int? bibleId) async {
    if (bibleId == null) {
      return emit(state.copyWith(status: ThreeTapNavigatorStatus.error));
    }

    // cache the last bibleId
    if (_bibleId != bibleId) {
      _bibleId = bibleId;

      final result = await _repo.getBooks(bibleId: bibleId);

      return result.fold(
        (f) => emit(state.copyWith(
          status: ThreeTapNavigatorStatus.error,
          books: [],
        )),
        (b) => emit(state.copyWith(
          status: ThreeTapNavigatorStatus.loaded,
          books: b,
        )),
      );
    }
  }

  Future<void> getMaxChapter(int bookId) async {
    if (!_selectedBookIds.keys.contains(bookId)) {
      final result = await _repo.getMaxChapter(bookId: bookId);

      return result.fold(
        (f) => emit(state.copyWith(
          status: ThreeTapNavigatorStatus.error,
          maxChapter: 0,
        )),
        (maxChap) {
          emit(state.copyWith(
            status: ThreeTapNavigatorStatus.loaded,
            maxChapter: maxChap,
          ));
          _selectedBookIds[bookId] = maxChap;
        },
      );
    }

    return emit(state.copyWith(
      status: ThreeTapNavigatorStatus.loaded,
      maxChapter: _selectedBookIds[bookId],
    ));
  }

  Future<void> getMaxVerse(int bookId, int chapter) async {
    final uniqueKey = '$bookId-$chapter';

    if (!_selectedChapterIds.keys.contains(uniqueKey)) {
      final result = await _repo.getMaxVerse(bookId: bookId, chapter: chapter);

      return result.fold(
        (f) => emit(state.copyWith(
          status: ThreeTapNavigatorStatus.error,
          maxChapter: 0,
        )),
        (maxVer) {
          emit(state.copyWith(
            status: ThreeTapNavigatorStatus.loaded,
            maxVerse: maxVer,
          ));
          _selectedChapterIds[uniqueKey] = maxVer;
        },
      );
    }

    return emit(state.copyWith(
      status: ThreeTapNavigatorStatus.loaded,
      maxVerse: _selectedChapterIds[uniqueKey],
    ));
  }
}
