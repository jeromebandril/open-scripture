import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/usecases/usecase.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/repositories/translation_manager_repository.dart';

class UninstallTranslation implements FutureUseCase<void, String> {
  final TranslationManagerRepository repository;

  UninstallTranslation(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.uninstallTranslation(id);
  }
}
