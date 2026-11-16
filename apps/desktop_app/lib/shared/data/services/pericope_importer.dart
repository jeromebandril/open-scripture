import 'dart:io';

import '../datasources/drift_book_local_datasource_impl.dart';
import '../datasources/pericope_datasource.dart';
import '../../../features/pericopes_mgr/domain/entities/pericope.dart';
import '../../../features/pericopes_mgr/domain/entities/pericope_set.dart';
import '../../../features/pericopes_mgr/error/pericopes_mgr_exceptions.dart';
import '../../../features/pericopes_mgr/data/models/pericope_set_file.dart';

extension on PericopeSetFile {
  PericopeSet toDomainSet() => PericopeSet(
        extId: id,
        name: id,
        langIsoCode: language,
        attribution: attribution,
        versionNumber: version,
      );

  List<Pericope> toDomainPericopes() => [
        for (final e in entries)
          Pericope(
            title: e.title,
            bookId: e.bookId,
            startChapter: e.startChapter,
            startVerse: e.startVerse,
            endChapter: e.endChapter,
            endVerse: e.endVerse,
          ),
      ];
}

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
  final PericopeDatasource _pericopes;
  final BibleBookLocalDataSource _books;

  const PericopeImporter({
    required PericopeDatasource datasource,
    required BibleBookLocalDataSource bookDatasource,
  })  : _pericopes = datasource,
        _books = bookDatasource;

  Future<void> installBundled(
    Future<String> Function(String assetPath) loadAsset,
  ) async {
    final bookIds = await _books.getCanonicalBookIds();

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

      final installed = await _pericopes.getPericopeSetByExtId(file.id);
      if (installed != null && installed.versionNumber >= file.version)
        continue;

      await _pericopes.installPericopeSet(
        file.toDomainSet(),
        file.toDomainPericopes(),
      );
    }
  }

  /// Imports a user-provided JSON string.
  /// Throws [PericopeImportException] with a readable list of problems.
  Future<({String setExtId, int count})> importUserFile(String path) async {
    final bookIds = await _books.getCanonicalBookIds();
    final source = await File(path).readAsString();
    final file = PericopeSetFile.parse(source, bookIds: bookIds);

    if (kBundledPericopeSets.any((b) => b.extId == file.id)) {
      throw PericopeImportException([
        'The id "${file.id}" is reserved for a built-in set. '
            'Change "id" in the file and try again.',
      ]);
    }

    await _pericopes.installPericopeSet(
      file.toDomainSet(),
      file.toDomainPericopes(),
    );
    return (setExtId: file.id, count: file.entries.length);
  }
}
