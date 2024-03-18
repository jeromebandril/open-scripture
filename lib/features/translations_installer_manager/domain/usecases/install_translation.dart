import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/usecases/usecase.dart';

import '../../../../core/error/failure.dart';
import '../repositories/translation_manager_repository.dart';

class InstallUsfxTranslation implements FutureUseCase<bool, String> {
  TranslationManagerRepository repository;

  InstallUsfxTranslation(this.repository);

  @override
  Future<Either<Failure, bool>> call(String path) async {
    return await repository.installTranslation(path);
  }
}
