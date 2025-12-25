import 'package:drift/drift.dart';

import '../domain/entities/bible_meta.dart';
import 'database.dart';

extension BibleInstallQueries on AppDb {
  Future<int> _getOrCreateLanguageId({
    required String langEngName,
    String? langNativeName,
    String? langIsoCode,
  }) async {
    await into(languages).insert(
      LanguagesCompanion.insert(
        langEngName: langEngName,
        langNativeName: Value(langNativeName),
        langIsoCode: Value(langIsoCode),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    // Pick a stable lookup key. Prefer ISO code if present.
    if (langIsoCode != null && langIsoCode.isNotEmpty) {
      final row = await (select(languages)
            ..where((t) => t.langIsoCode.equals(langIsoCode)))
          .getSingle();
      return row.id;
    } else {
      final row = await (select(languages)
            ..where((t) => t.langEngName.equals(langEngName)))
          .getSingle();
      return row.id;
    }
  }

  Future<void> insertBibleMetadataOnly(BibleMeta meta) async {
    await transaction(() async {
      int? languageId;

      // Optional: only link language if you actually have language info
      if ((meta.langEngName ?? '').isNotEmpty ||
          (meta.langIsoCode ?? '').isNotEmpty) {
        final eng = (meta.langEngName?.isNotEmpty ?? false)
            ? meta.langEngName!
            : 'Unknown';

        languageId = await _getOrCreateLanguageId(
          langEngName: eng,
          langNativeName: meta.langNativeName,
          langIsoCode: meta.langIsoCode,
        );
      }

      await into(bibles).insert(
        BiblesCompanion.insert(
          extId: meta.extId,
          languageId: Value(languageId), // nullable
          bibleName: meta.bibleName,
          bibleNameAbbreviation: meta.abbreviation,
          originSource: Value(meta.originSource),
        ),
        mode: InsertMode.insertOrIgnore, // ✅ idempotent install
      );
    });
  }
}
