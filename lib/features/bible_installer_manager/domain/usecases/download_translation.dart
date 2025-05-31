import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/domain/usecases/usecase.dart';

import '../repositories/translation_manager_repository.dart';

class DownloadTranslation implements FutureUseCase<Stream<List<int>>, String> {
  final TranslationManagerRepository repository;

  DownloadTranslation(this.repository);

  @override
  Future<Either<Failure, Stream<List<int>>>> call(String id) async {
    return await repository.downloadTranslation(id);
  }
}
