import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/usecases/usecase.dart';

import '../../../../core/error/failure.dart';
import '../entities/translation_info.dart';
import '../repositories/translation_manager_repository.dart';

class GetTranslationsInfoList
    implements StreamUseCase<List<TranslationInfo>, void> {
  final TranslationManagerRepository repository;

  GetTranslationsInfoList(this.repository);

  @override
  Stream<Either<Failure, List<TranslationInfo>>> call(_) {
    return repository.getAllTranslationsList();
  }
}
