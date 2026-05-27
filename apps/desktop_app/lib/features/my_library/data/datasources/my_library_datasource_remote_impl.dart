import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_scripture/features/my_library/data/datasources/my_library_datasource.dart';
import 'package:open_scripture/shared/constants.dart' as constants;
import 'package:open_scripture/shared/entities/bible_meta.dart';

class MyLibraryDatasourceRemoteImpl implements MyLibraryDatasource {
  static const _base = constants.getBibleApiUrl;

  List<BibleMeta>? _cachedTranslations;

  @override
  Future<BibleMeta> getBible(Object id) {
    if (_cachedTranslations == null) throw Error();
    return Future.value(_cachedTranslations!.firstWhere((t) => t.id == id));
  }

  @override
  Future<List<BibleMeta>> getBibles() async {
    if (_cachedTranslations != null) return _cachedTranslations!;

    final response = await http.get(Uri.parse('$_base/translations.json'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load translations');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);
    _cachedTranslations = json.entries.map((e) {
      final data = e.value as Map<String, dynamic>;
      return BibleMeta(
        id: data['abbreviation'].hashCode,
        bibleNameLocal: data['translation'] as String,
        bibleName: data['translation'] as String,
        abbreviation: data['abbreviation'],
        langEngName: data['language'] as String,
        extId: data['abbreviation'],
      );
    }).toList();

    return _cachedTranslations!;
  }

  @override
  Stream<List<BibleMeta>> watchBibles() async* {
    yield await getBibles();
  }
}
