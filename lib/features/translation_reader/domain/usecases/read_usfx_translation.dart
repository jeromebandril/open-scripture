import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../translations_installer_manager/domain/entities/translation.dart';
import '../repositories/reader_repository.dart';

class ReadUsfxTranslation implements FutureUseCase<Translation, String> {
  final ReaderRepository repository;

  ReadUsfxTranslation(this.repository);

  @override
  Future<Either<Failure, Translation>> call(String id) async {
    return await repository.getTranslation(id);
  }
}
