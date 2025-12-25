import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DriftDatabase(
  include: {'tables.drift'},
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // upgrade step-by-step
          if (from < 2) {
            // changes introduced in v2
            // await m.addColumn(table, table.newColumn);
            // await m.createTable(newTable);
            // await m.createIndex(someIndex);
            // await customStatement('UPDATE ...');
          }
          if (from < 3) {
            // changes introduced in v3
          }
        },
        beforeOpen: (details) async {
          // runs after create/upgrade, before DB is used
          // good place for PRAGMAs, sanity checks, seed data, etc.
        },
      );
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
