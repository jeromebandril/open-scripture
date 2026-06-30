import '../../models/bible_install_dto.dart';

abstract class BibleCatalogDatasource {
  /// Fetches a one-shot list of available bibles.
  Future<List<TranslationInstallDto>> getBibles();

  /// Retrieves metadata for a specific bible.
  Future<TranslationInstallDto> getBible(String extId);

  /// Watches the local database for installations or deletions.
  Stream<List<TranslationInstallDto>> watchBibles();
}
