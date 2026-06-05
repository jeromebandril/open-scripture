import 'dart:convert';

import 'package:open_scripture/core/sword/sword_bridge.dart';
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import 'package:open_scripture/shared/data/models/bible_install_dto.dart';

class SwordBibleCatalogDatasourceImpl implements BibleCatalogDatasource {
  final SwordBridge _swordBridge;

  const SwordBibleCatalogDatasourceImpl({required SwordBridge swordBridge})
      : _swordBridge = swordBridge;

  @override
  Future<TranslationInstallDto> getBible(String extId) {
    // TODO: implement getBible
    throw UnimplementedError();
  }

  @override
  Future<List<TranslationInstallDto>> getBibles() {
    final modulesJson = _swordBridge.listModules();
    final modules = jsonDecode(modulesJson) as List;
    final translations = modules.map((m) => TranslationInstallDto(
          extId: m['keyText'],
          name: m['name'],
          abbreviation: m['keyText'],
          description: m['description'],
          langNativeName: m['language'],
        ));

    return Future.value(translations.toList());
  }

  @override
  Stream<List<TranslationInstallDto>> watchBibles() {
    // TODO: implement watchBibles
    throw UnimplementedError();
  }
}
