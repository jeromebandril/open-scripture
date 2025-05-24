import 'package:the_smyrna_bible_v2/core/data/models/verse_model.dart';
import 'package:the_smyrna_bible_v2/core/database/database.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/domain/entities/bible_reference.dart';

abstract class BibleLocalDatasource {
  Future<List<VerseModel>> getVerses(BibleReference ref);
}

class BibleLocalDatasourceImpl implements BibleLocalDatasource {
  final AppDb db;

  const BibleLocalDatasourceImpl({required this.db});

  @override
  Future<List<VerseModel>> getVerses(BibleReference ref) async {
    final queryResult = await db.getVerses(
      ref.book!,
      ref.bibleId!,
      ref.chapter!,
      ref.verseStart,
      ref.verseEnd,
    );


    return queryResult.map((r) => VerseModel.fromDatabase(r)).toList();
}
