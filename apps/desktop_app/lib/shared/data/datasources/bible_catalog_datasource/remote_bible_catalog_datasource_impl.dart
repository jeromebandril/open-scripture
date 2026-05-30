import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import 'package:open_scripture/shared/data/models/bible_install_dto.dart';

class RemoteBibleCatalogDatasourceImpl implements BibleCatalogDatasource {
  final String baseUrl;
  List<TranslationInstallDto>? _cachedTranslations;

  RemoteBibleCatalogDatasourceImpl({required this.baseUrl});

  @override
  Future<List<TranslationInstallDto>> getBibles() async {
    if (_cachedTranslations != null) return _cachedTranslations!;

    final response = await http.get(Uri.parse('$baseUrl/translations.json'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load translations from API');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    _cachedTranslations = json.entries.map((e) {
      final data = e.value as Map<String, dynamic>;
      return TranslationInstallDto(
        extId: data['abbreviation'],
        name: data['translation'] as String,
        abbreviation: data['abbreviation'] as String,
        description: data['language'] as String,
      );
    }).toList();

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
