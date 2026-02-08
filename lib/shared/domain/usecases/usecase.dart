import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/error/failure.dart';

abstract class FutureUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}
