import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/usecases/usecase.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/scripture_finder/domain/entity/bible_reference.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/repositories/reader_repository.dart';

class DisplayChapter implements FutureUseCase<BibleReference, BibleReference> {
  ReaderRepository repository;

  DisplayChapter(this.repository);

  @override
  Future<Either<Failure, BibleReference>> call(BibleReference reference) async {
    return await repository.displayChapter(reference);
  }
}
