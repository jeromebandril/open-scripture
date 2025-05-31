import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/domain/usecases/usecase.dart';

import '../../../../core/error/failure.dart';
import '../entities/translation_info.dart';
import '../repositories/translation_manager_repository.dart';

class GetTranslationsInfoList
    implements FutureUseCase<List<TranslationInfo>, void> {
  final TranslationManagerRepository repository;

  GetTranslationsInfoList(this.repository);

  @override
  Future<Either<Failure, List<TranslationInfo>>> call(_) {
    return repository.getAllTranslationsList();
  }
}
