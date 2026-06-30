import '../../../../core/infrastructure/database/daos/bible_installation_dao.dart';
import '../../models/bible_install_dto.dart';

abstract class BibleInstallationDataSource {
  /// Installs the fully parsed Bible into the local infrastructure.
  Future<int> installBible({
    required String languageEnglishName,
    required String languageIsoCode,
    required String? languageNativeName,
    required TranslationInstallDto translation,
    required List<BookInstallDto> books,
    required List<VerseSegmentInstallDto> segments,
  });

  Future<void> uninstallBible({required int bibleId});
}

class DriftBibleInstallationDataSourceImpl
    implements BibleInstallationDataSource {
  final BibleInstallationDao _dao;

  DriftBibleInstallationDataSourceImpl(this._dao);

  @override
  Future<int> installBible({
    required String languageEnglishName,
    required String languageIsoCode,
    required String? languageNativeName,
    required TranslationInstallDto translation,
    required List<BookInstallDto> books,
    required List<VerseSegmentInstallDto> segments,
  }) {
    return _dao.executeInstallation(
      languageEnglishName: languageEnglishName,
      languageIsoCode: languageIsoCode,
      languageNativeName: languageNativeName,
      translation: translation,
      books: books,
      segments: segments,
    );
  }

  @override
  Future<void> uninstallBible({required int bibleId}) async {
    await _dao.executeUninstallation(bibleId);
  }
}
