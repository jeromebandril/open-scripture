import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../../../shared/domain/entities/bible_book.dart';
import '../database.dart';

part 'pericopes_dao.g.dart';

@DriftAccessor(tables: [PericopeSets, PericopeAssignments, Pericopes])
class PericopesDao extends DatabaseAccessor<AppDb> with _$PericopesDaoMixin {
  PericopesDao(super.db);

  Future<List<PericopeSet>> getAllPericopeSets() =>
      select(db.pericopeSets).get();

  Future<List<PericopeAssignment>> getAllPericopeAssignments() =>
      select(db.pericopeAssignments).get();

  Future<void> insertPericopeSet(PericopeSetsCompanion set) =>
      into(db.pericopeSets).insert(set);

  Future<void> updatePericopeSet(PericopeSet set) =>
      update(db.pericopeSets).replace(set);

  Future<void> deletePericopeSet(String extId) =>
      (delete(db.pericopeSets)..where((tbl) => tbl.extId.equals(extId))).go();

  Future<void> insertOrUpdatePericopeAssignment({
    required String setExtId,
    required String langIsoCode,
  }) async {
    int? resolvedSetId;

    final matchingSet = await (select(db.pericopeSets)
          ..where((tbl) => tbl.extId.equals(setExtId)))
        .getSingleOrNull();

    resolvedSetId = matchingSet?.id;

    await into(db.pericopeAssignments).insertOnConflictUpdate(
      PericopeAssignmentsCompanion(
        langIsoCode: Value(langIsoCode),
        setId: Value(resolvedSetId),
      ),
    );
  }

  Future<void> deletePericopeAssignment(String langIsoCode) async =>
      (delete(db.pericopeAssignments)
            ..where((tbl) => tbl.langIsoCode.equals(langIsoCode)))
          .go();

  Future<List<Pericope>> getForChapter(
    String bibleExtId,
    BibleBook book,
    int chapter,
  ) async {
    final isoCode = await _languageOf(bibleExtId);
    if (isoCode == null) return const [];
    print('data: lang=$isoCode book=${book.osisIndex} chapter=$chapter');

    final query = db.select(db.pericopes).join([
      innerJoin(
        db.pericopeAssignments,
        db.pericopeAssignments.setId.equalsExp(db.pericopes.setId),
      ),
    ])
      ..where(
        db.pericopeAssignments.langIsoCode.equals(isoCode) &
            db.pericopes.bookId.equals(book.osisIndex) &
            db.pericopes.startChapter.equals(chapter),
      )
      ..orderBy([
        OrderingTerm.asc(db.pericopes.startChapter),
        OrderingTerm.asc(db.pericopes.startVerse),
      ]);

    final result = await query.map((r) => r.readTable(db.pericopes)).get();

    return result;
  }

  Future<String?> _languageOf(String bibleExtId) async {
    final query = db.select(db.languages).join([
      innerJoin(db.bibles, db.bibles.languageId.equalsExp(db.languages.id)),
    ])
      ..where(db.bibles.extId.equals(bibleExtId));

    final row =
        await query.map((r) => r.readTable(db.languages)).getSingleOrNull();
    return row?.isoCode;
  }
}
