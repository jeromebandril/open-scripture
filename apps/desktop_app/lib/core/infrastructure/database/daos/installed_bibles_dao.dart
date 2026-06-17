import 'package:drift/drift.dart';
import 'package:open_scripture/core/infrastructure/database/database.dart';

part 'installed_bibles_dao.g.dart';

@DriftAccessor(tables: [Bibles])
class InstalledBiblesDao extends DatabaseAccessor<AppDb>
    with _$InstalledBiblesDaoMixin {
  InstalledBiblesDao(super.db);

  Future<List<Bible>> getAllBibles() => select(db.bibles).get();

  Future<Bible> getBibleByExtId(String extId) {
    return (select(db.bibles)..where((b) => b.extId.equals(extId))).getSingle();
  }

  Stream<List<Bible>> watchAllBibles() => select(db.bibles).watch();
}
