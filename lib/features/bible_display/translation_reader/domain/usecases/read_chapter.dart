import 'package:fpdart/fpdart.dart';

import '../../../../../core/domain/entities/bible_reference.dart';
import '../../../../../core/domain/usecases/usecase.dart';
import '../../../../../core/error/failure.dart';
import '../entities/page.dart';
import '../repositories/reader_repository.dart';

class ReadChapter implements FutureUseCase<PageContent, BibleRef> {
  ReaderRepository repository;

  ReadChapter(this.repository);

  @override
  Future<Either<Failure, PageContent>> call(BibleRef reference) async {
    return await repository.getChapter(reference);
  }
}
