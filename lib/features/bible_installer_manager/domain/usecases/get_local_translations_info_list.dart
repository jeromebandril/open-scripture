import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/e_bible.dart';
import 'package:the_smyrna_bible_v2/core/domain/usecases/usecase.dart';

import '../../../../core/error/failure.dart';
import '../repositories/translation_manager_repository.dart';

class GetLocalTranslationsInfoList
    implements FutureUseCase<List<EBible>, void> {
  final TranslationManagerRepository repository;

  GetLocalTranslationsInfoList(this.repository);

  @override
  Future<Either<Failure, List<EBible>>> call(_) {
    return repository.getAllInstalledBibles();
  }
}
