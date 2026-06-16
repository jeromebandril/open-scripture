import 'package:drift/drift.dart';
import 'package:open_scripture/core/infrastructure/database/daos/bible_content_dao.dart';
import 'package:open_scripture/core/infrastructure/database/daos/bible_installation_dao.dart';
import 'package:open_scripture/core/infrastructure/database/daos/installed_bibles_dao.dart';
import 'package:open_scripture/shared/domain/entities/bible_book.dart';

import 'db_connect/db_connect.dart';

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
