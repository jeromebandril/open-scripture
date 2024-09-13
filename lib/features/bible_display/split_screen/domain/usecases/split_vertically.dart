import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/domain/usecases/usecase.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/domain/entities/split_configuration.dart';

// ignore: constant_identifier_names
const MAX_VERTICAL_SPLIT = 2;

class SplitVertically
    implements FutureUseCase<SplitConfiguration, SplitConfiguration> {
  @override
  Future<Either<Failure, SplitConfiguration>> call(old) {
    late Either<Failure, SplitConfiguration> value;

    if (old.horizontal.length >= MAX_VERTICAL_SPLIT) {
      value = const Left(SplitFailure());
    } else {
      value = Right(
        SplitConfiguration(
          horizontal: old.horizontal,
          vertical: [...old.vertical, 1],
        ),
      );
    }

    return Future.value(value);
  }
}
