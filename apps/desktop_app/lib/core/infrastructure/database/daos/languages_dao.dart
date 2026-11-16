import 'package:drift/drift.dart';
import 'package:sealed_languages/sealed_languages.dart';
import '../database.dart';

part 'languages_dao.g.dart';

@DriftAccessor(tables: [Languages])
class LanguagesDao extends DatabaseAccessor<AppDb> with _$LanguagesDaoMixin {
  LanguagesDao(super.db);

  /// Get or insert language row
  Future<int?> getOrCreateLanguageId({
    String? code,
    String? engName,
    String? nativeName,
  }) async {
    final known = _tryLookup(
      rawCode: code,
      rawEngName: engName,
      rawNativeName: nativeName,
    );

    if (known == null) return null;

    await into(db.languages).insert(
      LanguagesCompanion.insert(
        isoCode: known.$1,
        engName: known.$2,
        nativeName: Value(known.$3),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    final row = await (select(db.languages)
          ..where((t) => t.isoCode.equals(known.$1)))
        .getSingle();
    return row.id;
  }

  // try to normalize and complete language informations
  // returns `null` if nothing matches.
  (String code, String englishName, String nativeName)? _tryLookup({
    String? rawCode,
    String? rawEngName,
    String? rawNativeName,
  }) {
    final attempts = {
      "code": rawCode,
      "engName": rawEngName,
      "nativeName": rawNativeName
    };

    for (var entry in attempts.entries) {
      if (entry.value == null) continue;

      String cleaned = entry.value!
          .trim()
          .replaceAll('_', '-')
          .split('-')
          .first
          .toLowerCase();
      if (cleaned.isEmpty) continue;

      final language = NaturalLanguage.maybeFromAnyCode(cleaned);
      if (language == null) continue;

      return (language.code, language.name, language.namesNative.first);
    }
    return null;
  }
}
