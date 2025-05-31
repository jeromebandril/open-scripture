import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/domain/usecases/usecase.dart';

import '../../../../core/error/failure.dart';
import '../repositories/translation_manager_repository.dart';

class InstallUsfxTranslation implements FutureUseCase<void, String> {
  TranslationManagerRepository repository;

  InstallUsfxTranslation(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return Future.value(Right(await repository.installTranslation(id)));
  }
}
