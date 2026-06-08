import 'dart:convert';

import 'package:open_scripture/core/sword/sword_bridge.dart';
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import 'package:open_scripture/shared/data/models/bible_install_dto.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';

class SwordBibleCatalogDatasourceImpl implements BibleCatalogDatasource {
  final SwordBridge _swordBridge;

  const SwordBibleCatalogDatasourceImpl({required SwordBridge swordBridge})
      : _swordBridge = swordBridge;

  @override
  Future<TranslationInstallDto> getBible(String extId) {
    final moduleJson = _swordBridge.getModuleInfo(extId);
    final m = jsonDecode(moduleJson);

    return Future.value(TranslationInstallDto(
      extId: m['name'],
      name: m['name'],
      abbreviation: m['name'],
      description: m['description'],
      langNativeName: m['language'],
      repoType: BibleRepositoryType.sword,
    ));
  }

  @override
  Future<List<TranslationInstallDto>> getBibles() {
    final modulesJson = _swordBridge.listBibles();

    final modules = jsonDecode(modulesJson) as List;
    final translations = modules.map((m) => TranslationInstallDto(
          extId: m['name'],
          name: m['name'],
          abbreviation: m['name'],
          description: m['description'],
          langNativeName: m['language'],
          repoType: BibleRepositoryType.sword,
        ));

    return Future.value(translations.toList());
  }

  @override
  Stream<List<TranslationInstallDto>> watchBibles() {
    // TODO: implement watchBibles
    throw UnimplementedError();
  }
}
