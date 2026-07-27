import 'dart:convert';

import '../../../error/exception.dart';
import '../../models/bible_install_dto.dart';
import '../../services/sword_service.dart';
import 'bible_catalog_datasource.dart';

class SwordBibleCatalogDatasourceImpl implements BibleCatalogDatasource {
  final SwordService _swordBridge;

  const SwordBibleCatalogDatasourceImpl({required SwordService swordService})
      : _swordBridge = swordService;

  @override
  Future<TranslationInstallDto> getBible(String extId) async {
    final bridge = await _swordBridge.instance;
    final moduleJson = bridge.getModuleInfo(extId);

    if (moduleJson.isEmpty || moduleJson == 'null' || moduleJson == '{}') {
      throw NotFoundException('No module found for "$extId"');
    }

    try {
      final m = jsonDecode(moduleJson) as Map<String, dynamic>;
      return TranslationInstallDtoMapper.fromSwordEngine(m);
    } on NotFoundException {
      rethrow;
    } catch (e, st) {
      throw SwordException(
        'Malformed module info for "$extId": $e',
        cause: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<TranslationInstallDto>> getBibles() async {
    final bridge = await _swordBridge.instance;
    final modulesJson = bridge.listBibles();

    try {
      final modules = jsonDecode(modulesJson) as List;
      return modules
          .map((m) => TranslationInstallDtoMapper.fromSwordEngine(
              m as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      throw SwordException(
        'Malformed modules list from SWORD bridge: $e',
        cause: e,
        stackTrace: st,
      );
    }
  }

  @override
  Stream<List<TranslationInstallDto>> watchBibles() {
    // TODO: implement watchBibles
    throw UnimplementedError();
  }
}
