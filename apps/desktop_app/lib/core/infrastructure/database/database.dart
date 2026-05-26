import 'package:drift/drift.dart';

import 'db_connect/db_connect.dart';

part 'database.g.dart';

@DriftDatabase(
  include: {
    'tables/core_tables.drift',
    'tables/verse_fts5.drift',
    'queries/core_queries.drift',
    'queries/add_queries.drift',
  },
)
class AppDb extends _$AppDb {
  AppDb() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {},
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );
}
