import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/bible_view_colorscheme.dart';

abstract class ColorschemeDatasource {
  Future<List<BibleViewColorscheme>> load();
  Future<void> save(BibleViewColorscheme cs);
  Future<void> delete(String name);
}

class ColorschemeDatasourceImpl implements ColorschemeDatasource {
  static const _key = 'bibleview.colorscheme';

  SharedPreferences? _prefs;

  ColorschemeDatasourceImpl();

  Future<SharedPreferences> _getInstance() async {
    if (_prefs != null) return Future.value(_prefs);
    _prefs = await SharedPreferences.getInstance();
    return Future.value(_prefs);
  }

  @override
  Future<List<BibleViewColorscheme>> load() async {
    final prefs = await _getInstance();
    final value = prefs.getString(_key);
    if (value == null) return [];
    final list = jsonDecode(value) as List;
    return list.map((e) => BibleViewColorscheme.fromJson(e)).toList();
  }

  @override
  Future<void> save(BibleViewColorscheme cs) async {
    final prefs = await _getInstance();
    final current = await load();
    prefs.setString(
      _key,
      jsonEncode([cs, ...current].map((e) => e.toJson()).toList()),
    );
    return;
  }

  @override
  Future<void> delete(String name) async {
    final prefs = await _getInstance();
    final current = await load();
    prefs.setString(
      _key,
      jsonEncode(
        current.where((e) => e.name != name).map((e) => e.toJson()).toList(),
      ),
    );
    return;
  }
}
