import 'package:open_scripture/shared/domain/entities/bible_book.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/entities/verse.dart';

abstract class BibleContentRepository {
  Future<List<Verse>> getChapter(
    BibleId bibleId,
    BibleBook book,
    int chapter,
  );
}
