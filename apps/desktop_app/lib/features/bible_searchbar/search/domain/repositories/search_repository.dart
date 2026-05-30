import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/error/failure.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';

abstract class SearchRepository {
  Future<Either<Failure, BibleRef>> parse(String query);

  // TODO: will implement in the future, firsta let's make the easiest part
  // Future<Either<Failure, List<BibleRef>>> find({
  //   required List<int> bibleIds,
  //   required String match,
  // });
}
