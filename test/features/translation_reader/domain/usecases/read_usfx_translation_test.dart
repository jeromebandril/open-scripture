import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/usecases/usecase.dart';
import 'package:the_smyrna_bible_v2/features/translation_reader/domain/repositories/reader_repository.dart';
import 'package:the_smyrna_bible_v2/features/translation_reader/domain/usecases/read_usfx_translation.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/entities/translation.dart';

import 'close_usfx_translation_test.mocks.dart';

@GenerateMocks([ReaderRepository])
void main() {
  late ReadUsfxTranslation usecase;
  late MockReaderRepository mockReaderRepository;

  setUp(
    () {
      mockReaderRepository = MockReaderRepository();
      usecase = ReadUsfxTranslation(mockReaderRepository);
    },
  );

  group(
    'try to read a translation',
    () {
      const id = 'eng-kjv';

      const translation = Translation(
        name: 'king james version',
        abbreviation: 'kjv',
        language: 'english',
        bookNames: {},
      );

      provideDummy<Either<Failure, Translation>>(const Right(translation));

      test(
        'should return the translation from transation manager when present',
        () async {
          when(mockReaderRepository.getTranslation(any))
              .thenAnswer((_) async => const Right(translation));

          final result = await usecase(const Params(id: id));

          expect(result, const Right(translation));
          verify(mockReaderRepository.getTranslation(id));
          verifyNoMoreInteractions(mockReaderRepository);
        },
      );

      test(
        'should return NoLoadedData from translation manager when it is not present',
        () async {
          when(mockReaderRepository.getTranslation(any))
              .thenAnswer((_) async => const Left(NoLoadedDataFailure()));

          final result = await usecase(const Params(id: id));

          expect(result, const Left(NoLoadedDataFailure()));
          verify(mockReaderRepository.getTranslation(id));
          verifyNoMoreInteractions(mockReaderRepository);
        },
      );
    },
  );
}
