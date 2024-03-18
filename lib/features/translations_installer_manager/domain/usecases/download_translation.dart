import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/usecases/usecase.dart';

import '../repositories/translation_manager_repository.dart';

class DownloadTranslation implements StreamUseCase<List<int>, String> {
  final TranslationManagerRepository repository;

  DownloadTranslation(this.repository);

  @override
  Stream<Either<Failure, List<int>>> call(String id) {
    return repository.downloadTranslation(id);
  }
}
