import '../../features/translations_installer_manager/domain/entities/translation.dart';
import '../../features/translations_installer_manager/domain/entities/translation_manager.dart';

class TranslationManagerModel extends TranslationManager {
  TranslationManagerModel();

  Translation? getUsfxTranslation(String id) {
    return localTranslations[id];
  }

  bool closeUsfxTranslation(String id) {
    if (localTranslations.containsKey(id)) {
      localTranslations.remove(id);
      return true;
    } else {
      return false;
    }
  }
}
