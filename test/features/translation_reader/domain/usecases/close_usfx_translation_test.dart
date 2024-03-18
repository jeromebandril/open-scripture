import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:the_smyrna_bible_v2/features/translation_reader/domain/repositories/reader_repository.dart';
import 'package:the_smyrna_bible_v2/features/translation_reader/domain/usecases/close_usfx_translation.dart';

import 'close_usfx_translation_test.mocks.dart';

@GenerateMocks([ReaderRepository])
void main() {
  late CloseUsfxTranslation usecase;
  late MockReaderRepository mockReaderRepository;

  setUp(
    () {
      mockReaderRepository = MockReaderRepository();
      usecase = CloseUsfxTranslation(mockReaderRepository);
    },
  );

  const id = 'eng-kjv';
  const isSuccess = true;

  group(
    'try to close the translation (hence remove it from Map)',
    () {
      test(
        'should close the traslation (hence remove it from Map) and return true',
        () {
          when(mockReaderRepository.removeTranslation(any))
              .thenReturn(isSuccess);

          final result = usecase(id);

          expect(result, isSuccess);
          verify(mockReaderRepository.removeTranslation(id));
          verifyNoMoreInteractions(mockReaderRepository);
        },
      );

      test(
        'should fail to close the traslation and return false',
        () {
          when(mockReaderRepository.removeTranslation(any))
              .thenReturn(!isSuccess);

          final result = usecase(id);

          expect(result, !isSuccess);
          verify(mockReaderRepository.removeTranslation(id));
          verifyNoMoreInteractions(mockReaderRepository);
        },
      );
    },
  );
}
