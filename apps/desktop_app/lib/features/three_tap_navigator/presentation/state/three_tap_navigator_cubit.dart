import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/bible_id.dart';
import '../../../../shared/domain/entities/bible_ref.dart';
import '../../../../shared/domain/entities/localized_book.dart';
import '../../domain/repository/three_tap_navigator_repository.dart';

part 'three_tap_navigator_state.dart';

class ThreeTapNavigatorCubit extends Cubit<ThreeTapNavigatorState> {
  ThreeTapNavigatorCubit({required ThreeTapNavigatorRepository repo})
      : _repo = repo,
        super(ThreeTapNavigatorState());

  BibleId? _bibleId;
  final ThreeTapNavigatorRepository _repo;
  final Map<String, int> _selectedBookIds = {};
  final Map<String, int> _selectedChapterIds = {};

  Future<void> loadBooks(BibleId? bibleId) async {
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

  Future<void> getChapterBoundary(String bookToken) async {
    if (!_selectedBookIds.keys.contains(bookToken)) {
      final result = await _repo.getChapterBoundaryOf(
        bookToken: bookToken,
      );

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
          _selectedBookIds[bookToken] = maxChap;
        },
      );
    }

    return emit(state.copyWith(
      status: ThreeTapNavigatorStatus.loaded,
      maxChapter: _selectedBookIds[bookToken],
    ));
  }

  Future<void> getVerseBoundary(String bookToken, int chapter) async {
    final uniqueKey = '$bookToken-$chapter';

    if (!_selectedChapterIds.keys.contains(uniqueKey)) {
      final result = await _repo.getVerseBoundaryOf(
        bookToken: bookToken,
        chapter: chapter,
      );

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
