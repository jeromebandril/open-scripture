import 'package:drift/drift.dart';

import '../../../../core/infrastructure/database/database.dart';
import '../models/pericope_set_file.dart';

class _BundledPericopeSet {
  const _BundledPericopeSet({required this.extId, required this.assetPath});
  final String extId;
  final String assetPath;
}

const kBundledPericopeSets = [
  _BundledPericopeSet(
    extId: 'kjv-en',
    assetPath: 'assets/pericopes/kjv-en.json',
  ),
];

class PericopeImporter {
  PericopeImporter(this._db);
  final AppDb _db;

  Future<void> installBundled(
    Future<String> Function(String assetPath) loadAsset,
  ) async {
    final bookIds = await _loadBookIds();

    for (final bundled in kBundledPericopeSets) {
      final file = PericopeSetFile.parse(
        await loadAsset(bundled.assetPath),
        bookIds: bookIds,
      );
      if (file.id != bundled.extId) {
        throw StateError(
          'Asset ${bundled.assetPath} has id "${file.id}", '
          'expected "${bundled.extId}"',
        );
      }

      final installed = await (_db.select(_db.pericopeSets)
            ..where((s) => s.extId.equals(file.id)))
          .getSingleOrNull();

      if (installed != null && installed.versionNumber >= file.version) {
        continue;
      }
      await _write(file);
    }
  }

  /// Imports a user-provided JSON string (file picker, drag and drop, ...).
  /// Throws [PericopeImportException] with a readable list of problems.
  Future<({int setId, int count})> importUserFile(String source) async {
    final file = PericopeSetFile.parse(source, bookIds: await _loadBookIds());

    if (kBundledPericopeSets.any((b) => b.extId == file.id)) {
      throw PericopeImportException([
        'The id "${file.id}" is reserved for a built-in set. '
            'Change "id" in the file and try again.',
      ]);
    }

    final setId = await _write(file);
    return (setId: setId, count: file.entries.length);
  }

  Future<Map<String, int>> _loadBookIds() async {
    final rows = await _db.select(_db.canonicalBooks).get();
    return {for (final b in rows) b.bookToken: b.id};
  }

  Future<int> _write(PericopeSetFile file) {
    return _db.transaction(() async {
      // 1. UPSERT the set. A plain REPLACE would delete the row and cascade
      //    away the user's assignments.
      await _db.into(_db.pericopeSets).insert(
            PericopeSetsCompanion.insert(
              extId: file.id,
              // name: file.name,
              langIsoCode: file.language,
              // version: Value(file.version),
              attribution: Value(file.attribution),
            ),
            onConflict: DoUpdate(
              (old) => PericopeSetsCompanion(
                // name: Value(file.name),
                langIsoCode: Value(file.language),
                // version: Value(file.version),
                attribution: Value(file.attribution),
              ),
              target: [_db.pericopeSets.extId],
            ),
          );

      // 2. Look the id up explicitly. The rowid returned by an upsert
      //    that took the UPDATE path isn't reliable.
      final setId = await (_db.select(_db.pericopeSets)
            ..where((s) => s.extId.equals(file.id)))
          .map((s) => s.id)
          .getSingle();

      // 3. Replace the set's rows.
      await (_db.delete(_db.pericopes)..where((p) => p.setId.equals(setId)))
          .go();

      await _db.batch((b) {
        b.insertAll(
          _db.pericopes,
          [
            for (final e in file.entries)
              PericopesCompanion.insert(
                setId: setId,
                bookId: e.bookId,
                startChapter: e.startChapter,
                startVerse: e.startVerse,
                endChapter: e.endChapter,
                endVerse: e.endVerse,
                title: e.title,
              ),
          ],
        );
      });

      await _db.into(_db.pericopeAssignments).insert(
            PericopeAssignmentsCompanion.insert(
              langIsoCode: file.language,
              setId: Value(setId),
            ),
            mode: InsertMode.insertOrIgnore,
          );

      return setId;
    });
  }
}
