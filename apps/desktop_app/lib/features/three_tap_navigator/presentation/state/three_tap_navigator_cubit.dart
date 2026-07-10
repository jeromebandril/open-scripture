import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/bible_book.dart';
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
  List<LocalizedBook>? _defaultBooks;
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
        (f) {
          // if error, default to pre-defined books
          _ensureDefaultBooks();

          emit(state.copyWith(
            status: ThreeTapNavigatorStatus.loaded,
            books: _defaultBooks,
            loadType: BookLoadType.defaulted,
          ));
        },
        (b) {
          if (b.isNotEmpty) {
            // free memory when default is not used
            _defaultBooks = null;
          } else {
            _ensureDefaultBooks();
          }

          emit(state.copyWith(
            status: ThreeTapNavigatorStatus.loaded,
            books: b.isNotEmpty ? b : _defaultBooks,
            loadType:
                b.isNotEmpty ? BookLoadType.localized : BookLoadType.defaulted,
          ));
        },
      );
    }
  }

  void _ensureDefaultBooks() {
    _defaultBooks ??= BibleBook.values
        .map((b) => LocalizedBook(
            book: b,
            longName: b.englishName,
            shortName: b.englishName,
            abbreviation: b.canonical))
        .toList();
  }

  Future<void> getChapterBoundary(String bookToken) async {
    // This is a temp workaround for default books
    // 150 is the higher num of chapters (from psalms)
    if (state.loadType == BookLoadType.defaulted) {
      return emit(state.copyWith(maxChapter: 150));
    }

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
    // This is a temp workaround for default books
    // 150 is the higher num of verses (from psalms 119)
    if (state.loadType == BookLoadType.defaulted) {
      return emit(state.copyWith(maxVerse: 176));
    }

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
