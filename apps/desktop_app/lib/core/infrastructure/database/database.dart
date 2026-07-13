import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../shared/domain/entities/bible_book.dart';
import 'daos/bible_content_dao.dart';
import 'daos/bible_installation_dao.dart';
import 'daos/installed_bibles_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  include: {
    'tables/core_tables.drift',
    // TODO: disable for the moment, until refactor is complete
    // 'tables/verse_fts5.drift',
  },
  daos: [
    BibleInstallationDao,
    BibleContentDao,
    InstalledBiblesDao,
  ],
)
class AppDb extends _$AppDb {
  AppDb() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();

          // Pre-fill the canonical lookup table instantly
          await batch((b) {
            final companions = BibleBook.values.map((book) {
              return CanonicalBooksCompanion.insert(
                bookToken: book.canonical,
                bookOrder: book.osisIndex,
              );
            }).toList();

            b.insertAll(canonicalBooks, companions);
          });
        },
        onUpgrade: (m, from, to) async {},
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );
}

QueryExecutor openConnection() {
  return driftDatabase(
    name: 'open_scripture',
    native: DriftNativeOptions(
      databasePath: () async {
        final dbFolder = await getApplicationSupportDirectory();
        final file =
            File(p.join(dbFolder.path, 'data', 'open_scripture.sqlite'));

        await file.parent.create(recursive: true);

        return file.path;
      },
    ),
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
