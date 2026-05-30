import 'package:open_scripture/core/infrastructure/database/daos/bible_installation_dao.dart';
import 'package:open_scripture/shared/data/models/bible_install_dto.dart';

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
}
