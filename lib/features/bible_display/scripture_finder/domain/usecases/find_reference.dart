import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/usecases/usecase.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/scripture_finder/domain/entity/bible_reference.dart';

class FindReference implements FutureUseCase<dynamic, BibleReference> {
  @override
  Future<Either<Failure, dynamic>> call(BibleReference reference) {
    throw UnimplementedError();
  }
}
