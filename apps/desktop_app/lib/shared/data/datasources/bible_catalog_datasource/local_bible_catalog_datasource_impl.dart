import 'package:drift/drift.dart';

import '../../../../core/infrastructure/database/database.dart';
import '../../../error/exception.dart';
import '../../models/bible_install_dto.dart';
import 'bible_catalog_datasource.dart';

class LocalBibleCatalogDataSourceImpl implements BibleCatalogDatasource {
  final AppDb db;

  LocalBibleCatalogDataSourceImpl(this.db);

  @override
  Future<List<TranslationInstallDto>> getBibles() async {
    final rows = await (db.select(db.bibles).join([
      innerJoin(
        db.languages,
        db.languages.id.equalsExp(db.bibles.languageId),
      ),
    ])).get();

    return rows
        .map((row) => TranslationInstallDtoMapper.fromDatabase(
              row.readTable(db.bibles),
              row.readTable(db.languages),
            ))
        .toList();
  }

  @override
  Future<TranslationInstallDto> getBible(String extId) async {
    final row = await (db.select(db.bibles).join([
      innerJoin(
        db.languages,
        db.languages.id.equalsExp(db.bibles.languageId),
      ),
    ])
          ..where(db.bibles.extId.equals(extId)))
        .getSingleOrNull();

    if (row == null) throw NotFoundException(extId);

    return TranslationInstallDtoMapper.fromDatabase(
      row.readTable(db.bibles),
      row.readTable(db.languages),
    );
  }

  @override
  Stream<List<TranslationInstallDto>> watchBibles() {
    // TODO: implement watchBibles
    throw UnimplementedError();
  }
}
