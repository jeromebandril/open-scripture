import 'package:drift/drift.dart';

import '../../../core/infrastructure/database/database.dart';
import '../../../features/pericopes_mgr/domain/entities/pericope.dart'
    as domain;
import '../../../features/pericopes_mgr/domain/entities/pericope_set.dart'
    as domain;
import '../../domain/entities/bible_book.dart' as domain;
import '../../domain/entities/bible_id.dart';

abstract class PericopeDatasource {
  Future<List<domain.PericopeSet>> getAllPericopeSets();

  Future<void> installPericopeSet(
    domain.PericopeSet pericopeSet,
    List<domain.Pericope> pericopes,
  );

  /// Insert or update the given pericope's metadata only.
  /// It doesn't change its content.
  Future<void> upsertPericopeSet(domain.PericopeSet pericopeSet);
  Future<void> deletePericopeSet(String extId);
  Future<void> deleteAssignemntByBibleId(BibleId bibleId);

  /// [setExtId] == null means the user explicitly chose "no pericopes"
  /// for this language
  Future<void> assignPericopeSetToLanguage({
    required String langIsoCode,
    String? setExtId,
  });

  /// Get using bible external id, matching in the db
  Future<List<domain.Pericope>> getForChapter({
    required BibleId bibleId,
    required domain.BibleBook book,
    required int chapter,
  });
  Future<domain.PericopeSet?> getPericopeSetByExtId(String extId);
  Future<String?> getAssignedPericopeSetForLanguage(String langIsoCode);
}

extension PericopeSetDto on domain.PericopeSet {
  static domain.PericopeSet fromJson(dynamic row) => domain.PericopeSet(
        name: row['name'],
        extId: row['extId'],
        versionNumber: row['versionNumber'],
        attribution: row['attribution'],
        assignedTo: [],
      );
}

class PericopeDatasourceImpl implements PericopeDatasource {
  final AppDb _db;

  const PericopeDatasourceImpl(this._db);

  Future<List<domain.PericopeSet>> _querySets({Expression<bool>? where}) async {
    final sets = _db.pericopeSets;
    final lang = _db.languages;
    final per = _db.pericopeAssignments;

    final query = _db.select(sets).join([
      leftOuterJoin(lang, lang.id.equalsExp(sets.languageId)),
    ])
      ..orderBy([OrderingTerm.asc(sets.extId)]);
    if (where != null) query.where(where);

    final asmt = await _db
        .select(per)
        .join([innerJoin(sets, sets.id.equalsExp(per.setId))]).get();

    return [
      for (final row in await query.get())
        domain.PericopeSet(
            name: row.readTable(sets).pericopeName,
            extId: row.readTable(sets).extId,
            versionNumber: row.readTable(sets).versionNumber,
            attribution: row.readTable(sets).attribution,
            langIsoCode: row.readTableOrNull(lang)?.isoCode,
            assignedTo: asmt
                .where((a) => a.readTable(sets).id == row.readTable(sets).id)
                .map((a) => BibleId.fromKey(a.readTable(per).bibleId))
                .toList()),
    ];
  }

  @override
  Future<List<domain.PericopeSet>> getAllPericopeSets() => _querySets();

  @override
  Future<void> installPericopeSet(
    domain.PericopeSet pericopeSet,
    List<domain.Pericope> pericopes,
  ) {
    return _db.transaction(() async {
      // 1. Resolve the language (optional on the entity).
      final isoCode = pericopeSet.langIsoCode;
      final languageId = isoCode == null
          ? null
          : await _db.languagesDao.getOrCreateLanguageId(code: isoCode);

      // 2. Upsert the set's metadata.
      await _db.into(_db.pericopeSets).insert(
            PericopeSetsCompanion.insert(
              extId: pericopeSet.extId,
              pericopeName: Value(pericopeSet.name),
              languageId: Value(languageId),
              attribution: Value(pericopeSet.attribution),
              versionNumber: Value(pericopeSet.versionNumber),
            ),
            onConflict: DoUpdate(
              (old) => PericopeSetsCompanion(
                languageId: Value(languageId),
                attribution: Value(pericopeSet.attribution),
              ),
              target: [_db.pericopeSets.extId],
            ),
          );

      // 3. Look the id up explicitly. The rowid returned by an upsert
      //    that took the UPDATE path isn't reliable.
      final setId = await (_db.select(_db.pericopeSets)
            ..where((s) => s.extId.equals(pericopeSet.extId)))
          .map((s) => s.id)
          .getSingle();

      // 4. Replace the set's pericopes.
      await (_db.delete(_db.pericopes)..where((p) => p.setId.equals(setId)))
          .go();
      await _db.batch((b) {
        b.insertAll(
          _db.pericopes,
          [
            for (final p in pericopes)
              PericopesCompanion.insert(
                setId: setId,
                bookId: p.bookId,
                startChapter: p.startChapter,
                startVerse: p.startVerse,
                endChapter: p.endChapter,
                endVerse: p.endVerse,
                title: p.title,
              ),
          ],
        );
      });
    });
  }

  @override
  Future<void> upsertPericopeSet(domain.PericopeSet pericopeSet) async {
    final languageId = await _db.languagesDao.getOrCreateLanguageId(
      code: pericopeSet.langIsoCode,
    );

    final data = PericopeSetsCompanion.insert(
      extId: pericopeSet.extId,
      languageId: Value(languageId),
      versionNumber: Value(pericopeSet.versionNumber),
      attribution: Value(pericopeSet.attribution),
    );

    // Upsert pericope set
    await _db.into(_db.pericopeSets).insert(
          data,
          onConflict: DoUpdate(
            (_) => data,
            target: [_db.pericopeSets.extId],
          ),
        );
  }

  @override
  Future<void> assignPericopeSetToLanguage({
    required String langIsoCode,
    String? setExtId,
  }) async {}

  @override
  Future<void> deletePericopeSet(String extId) async =>
      (_db.delete(_db.pericopeSets)..where((tbl) => tbl.extId.equals(extId)))
          .go();

  @override
  Future<void> deleteAssignemntByBibleId(BibleId bibleId) async =>
      await (_db.delete(_db.pericopeAssignments)
            ..where((a) => a.bibleId.equals(bibleId.key)))
          .go();

  @override
  Future<List<domain.Pericope>> getForChapter({
    required BibleId bibleId,
    required domain.BibleBook book,
    required int chapter,
  }) async {
    final query = _db.select(_db.pericopes).join([
      innerJoin(
        _db.pericopeAssignments,
        _db.pericopeAssignments.setId.equalsExp(_db.pericopes.setId),
      ),
    ])
      ..where(
        _db.pericopeAssignments.bibleId.equals(bibleId.key) &
            _db.pericopes.bookId.equals(book.osisIndex) &
            _db.pericopes.startChapter.equals(chapter),
      )
      ..orderBy([OrderingTerm.asc(_db.pericopes.startVerse)]);

    final rows = await query.map((r) => r.readTable(_db.pericopes)).get();

    return rows
        .map((r) => domain.Pericope(
              bookId: r.bookId,
              startChapter: r.startChapter,
              startVerse: r.startVerse,
              endChapter: r.endChapter,
              endVerse: r.endVerse,
              title: r.title,
            ))
        .toList();
  }

  @override
  Future<domain.PericopeSet?> getPericopeSetByExtId(String extId) async =>
      (await _querySets(where: _db.pericopeSets.extId.equals(extId)))
          .firstOrNull;

  @override
  Future<String?> getAssignedPericopeSetForLanguage(String langIsoCode) {
    // TODO: implement getAssignedPericopeSetForLanguage
    throw UnimplementedError();
  }
}
