import 'package:open_scripture/core/infrastructure/database/database.dart';
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import 'package:open_scripture/shared/data/models/bible_install_dto.dart';

class LocalBibleCatalogDataSourceImpl implements BibleCatalogDatasource {
  final AppDb db;

  LocalBibleCatalogDataSourceImpl(this.db);

  @override
  Future<List<TranslationInstallDto>> getBibles() async {
    // Assuming you have a basic query or DAO to get all bibles
    final rows = await db.select(db.bibles).get();
    return rows.map(TranslationInstallDtoMapper.fromDatabase).toList();
  }

  @override
  Future<TranslationInstallDto> getBible(String extId) async {
    final row = await (db.select(db.bibles)
          ..where((b) => b.extId.equals(extId)))
        .getSingle();

    return TranslationInstallDtoMapper.fromDatabase(row);
  }

  @override
  Stream<List<TranslationInstallDto>> watchBibles() {
    // TODO: implement watchBibles
    throw UnimplementedError();
  }
}
