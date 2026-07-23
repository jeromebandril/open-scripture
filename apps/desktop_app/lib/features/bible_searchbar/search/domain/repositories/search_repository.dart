import 'package:fpdart/fpdart.dart';
import '../../../../../shared/domain/entities/bible_ref_partial.dart';
import '../../../../../shared/error/failure.dart';

abstract class SearchRepository {
  TaskEither<Failure, BibleRefPartial> parse(String query);

  // TODO: will implement in the future, firsta let's make the easiest part
  // Future<Either<Failure, List<BibleRef>>> find({
  //   required List<int> bibleIds,
  //   required String match,
  // });
}
