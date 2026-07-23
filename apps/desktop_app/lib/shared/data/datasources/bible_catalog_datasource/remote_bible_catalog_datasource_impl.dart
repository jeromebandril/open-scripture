import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../enums/bible_repository_type.dart';
import '../../../error/exception.dart';
import '../../models/bible_install_dto.dart';
import 'bible_catalog_datasource.dart';

class RemoteBibleCatalogDatasourceImpl implements BibleCatalogDatasource {
  List<TranslationInstallDto>? _cachedTranslations;

  RemoteBibleCatalogDatasourceImpl();

  @override
  Future<List<TranslationInstallDto>> getBibles() async {
    if (_cachedTranslations != null) return _cachedTranslations!;
    final http.Response response;

    try {
      response =
          await http.get(Uri.parse('$kApiGetBibleV2Url/translations.json'));
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException {
      throw const NetworkException('Request timed out');
    }

    if (response.statusCode != 200) {
      throw ServerException(
        'Failed to load translations (status ${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

    final List<TranslationInstallDto> translations;
    try {
      final Map<String, dynamic> json = jsonDecode(response.body);
      translations = json.entries.map((e) {
        final data = e.value as Map<String, dynamic>;
        return TranslationInstallDto(
          extId: data['abbreviation'] as String,
          name: data['translation'] as String,
          description: data['description'] as String,
          abbreviation: data['abbreviation'] as String,
          langEngName: data['language'] as String,
          langIsoCode: data['lang'] as String,
          copyright: data['distribution_license'] as String,
          repoType: BibleRepositoryType.cloudAPI,
          originFormat: data['distribution_sourcetype'] as String,
        );
      }).toList();
    } catch (e) {
      throw ServerException('Malformed translations response: $e');
    }

    _cachedTranslations = translations;
    return _cachedTranslations!;
  }

  @override
  Future<TranslationInstallDto> getBible(String extId) async {
    final bibles = await getBibles(); // Ensures cache is loaded
    return bibles.firstWhere(
      (b) => b.extId == extId,
      orElse: () => throw Exception('Bible not found (extId=$extId)'),
    );
  }

  @override
  Stream<List<TranslationInstallDto>> watchBibles() {
    // TODO: implement watchBibles
    throw UnimplementedError();
  }
}
