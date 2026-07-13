import '../entities/bible_book.dart';
import '../entities/bible_id.dart';
import '../entities/verse.dart';

abstract class BibleContentRepository {
  Future<List<Verse>> getChapter(
    BibleId bibleId,
    BibleBook book,
    int chapter,
  );
}
