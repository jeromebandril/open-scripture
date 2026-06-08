import 'package:open_scripture/shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import 'package:open_scripture/shared/data/models/verse_segment_dto.dart';
import 'package:open_scripture/shared/domain/entities/bible_book.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/entities/verse.dart';
import 'package:open_scripture/shared/domain/repositories/bible_content_repository.dart';

class BibleContentRepositoryImpl implements BibleContentRepository {
  final BibleContentDatasource _dataSource;

  BibleContentRepositoryImpl(this._dataSource);

  @override
  Future<List<Verse>> getChapter(
    BibleId bibleId,
    BibleBook book,
    int chapter,
  ) async {
    final dtos = await _dataSource.getChapterWithSpans(
      bibleId,
      book,
      chapter,
    );

    final grouped = <int, List<VerseSegmentDto>>{};
    for (final row in dtos) {
      grouped.putIfAbsent(row.verseNumber, () => []).add(row);
    }

    // Build Verses
    return grouped.entries.map((entry) {
      final segmentsDtos = entry.value
        ..sort((a, b) => a.segmentIndex.compareTo(b.segmentIndex));

      return Verse(
        translationId: bibleId,
        ref: BibleRef(
          book: book,
          chapter: chapter,
          verseStart: entry.key,
        ),
        segments: segmentsDtos.map((dto) => dto.toDomain()).toList(),
      );
    }).toList();
  }
}
