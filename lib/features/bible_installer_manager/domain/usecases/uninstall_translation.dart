import 'package:the_smyrna_bible_v2/features/bible_installer_manager/domain/repositories/translation_manager_repository.dart';

class UninstallTranslation {
  final TranslationManagerRepository repository;

  UninstallTranslation(this.repository);

  Future call(String id) async {
    return await repository.uninstallTranslation(id);
  }
}
