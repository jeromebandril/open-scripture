import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/domain/usecases/usecase.dart';
import '../../../../../core/domain/entities/translation.dart';
import '../repositories/reader_repository.dart';

class OpenUsfxTranslation implements FutureUseCase<Translation, String> {
  final ReaderRepository repository;

  OpenUsfxTranslation(this.repository);

  @override
  Future<Either<Failure, Translation>> call(String id) async {
    return await repository.openTranslation(id);
  }
}
