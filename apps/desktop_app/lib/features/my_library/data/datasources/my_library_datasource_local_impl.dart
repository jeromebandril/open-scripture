import 'package:open_scripture/core/infrastructure/database/database.dart';
import 'package:open_scripture/features/my_library/data/datasources/my_library_datasource.dart';
import 'package:open_scripture/shared/entities/bible_meta.dart';
import 'package:open_scripture/core/di/injection_container.dart' as di;
import 'package:open_scripture/shared/error/exception.dart';

class MyLibraryDatasourceLocalImpl implements MyLibraryDatasource {
  final AppDb db = di.sl();

  @override
  Future<BibleMeta> getBible(Object id) async {
    try {
      final rows = await db.getBible(id as int).get();

      if (rows.isEmpty) {
        throw NotFoundException('Bible not found (id=$id)');
      }

      final r = rows.first;

      return BibleMeta(
        id: r.id,
        extId: r.extId,
        bibleName: r.bibleName,
        bibleNameLocal: r.bibleNameLocal,
        abbreviation: r.bibleNameAbbreviation,
        originSource: r.originSource,
        // language
        langEngName: r.langEngName,
        langIsoCode: r.langIsoCode,
        langNativeName: r.langNativeName,
      );
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw LocalDataException(
        'Failed to load bible metadata (id=$id)',
        cause: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<BibleMeta>> getBibles() async {
    List<GetBiblesResult> rows = await db.getBibles().get();

    return rows
        .map((r) => BibleMeta(
              id: r.id,
              extId: r.extId,
              bibleName: r.bibleName,
              bibleNameLocal: r.bibleNameLocal,
              abbreviation: r.bibleNameAbbreviation,
              originSource: r.originSource,
              originFormat: r.originFormat,
              description: r.description,
              copyright: r.copyright,
              langEngName: r.langEngName,
              langIsoCode: r.langIsoCode,
              langNativeName: r.langNativeName,
            ))
        .toList();
  }

  @override
  Stream<List<BibleMeta>> watchBibles() {
    // TODO: implement watchBibles
    throw UnimplementedError();
  }
}
