import 'package:fpdart/fpdart.dart';

import '../../../../../core/domain/entities/translation.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/domain/usecases/usecase.dart';
import '../repositories/reader_repository.dart';

class GetTranslation implements FutureUseCase<Translation, String> {
  ReaderRepository repository;

  GetTranslation(this.repository);

  @override
  Future<Either<Failure, Translation>> call(String id) async {
    return await repository.getTranslation(id);
  }
}
