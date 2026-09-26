import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/slide_data.dart';

abstract class PresenterDatasource {
  Future<List<SlideData>> load();
  Future<void> save({required List<SlideData> slides});
}

class PresenterDatasourceImpl implements PresenterDatasource {
  static const _key = 'state.slides';

  SharedPreferences? _prefs;

  PresenterDatasourceImpl();

  Future<SharedPreferences> _getInstance() async {
    if (_prefs != null) return Future.value(_prefs);
    _prefs = await SharedPreferences.getInstance();
    return Future.value(_prefs);
  }

  @override
  Future<List<SlideData>> load() async {
    final prefs = await _getInstance();

    final value = prefs.getString(_key);
    if (value == null) return [];

    final list = jsonDecode(value) as List;

    return list
        .map((e) => SlideData.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> save({required List<SlideData> slides}) async {
    final prefs = await _getInstance();
    prefs.setString(
      _key,
      jsonEncode(slides.map((e) => e.toJson()).toList()),
    );
    return;
  }

  Future<void> clear() async => (await _getInstance()).remove(_key);
}
