import '../../domain/entities/bible_book.dart';
import '../../domain/entities/bible_id.dart';
import '../../domain/entities/bible_ref.dart';
import '../../domain/entities/verse.dart';
import '../../domain/repositories/bible_content_repository.dart';
import '../datasources/bible_content_datasource/bible_content_datasourcee.dart';
import '../models/verse_segment_dto.dart';

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
      bibleId.externalId,
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
        translationId: bibleId.externalId,
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
