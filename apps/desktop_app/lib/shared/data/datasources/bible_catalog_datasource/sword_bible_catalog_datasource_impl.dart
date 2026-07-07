import 'dart:convert';

import '../../models/bible_install_dto.dart';
import '../../services/sword_service.dart';
import 'bible_catalog_datasource.dart';

class SwordBibleCatalogDatasourceImpl implements BibleCatalogDatasource {
  final SwordService _swordBridge;

  const SwordBibleCatalogDatasourceImpl({required SwordService swordService})
      : _swordBridge = swordService;

  @override
  Future<TranslationInstallDto> getBible(String extId) async {
    final moduleJson = (await _swordBridge.instance).getModuleInfo(extId);
    final m = jsonDecode(moduleJson);

    return Future.value(TranslationInstallDtoMapper.fromSwordEngine(m));
  }

  @override
  Future<List<TranslationInstallDto>> getBibles() async {
    final modulesJson = (await _swordBridge.instance).listBibles();

    final modules = jsonDecode(modulesJson) as List;
    final translations =
        modules.map((m) => TranslationInstallDtoMapper.fromSwordEngine(m));

    return Future.value(translations.toList());
  }

  @override
  Stream<List<TranslationInstallDto>> watchBibles() {
    // TODO: implement watchBibles
    throw UnimplementedError();
  }
}
