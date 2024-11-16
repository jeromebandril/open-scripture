// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/exception.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/data/datasources/translation_manager_local_datasource.dart';
import 'package:the_smyrna_bible_v2/core/data/models/translation_model.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/data/datasources/translation_manager_remote_datasource.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/data/repositories/translation_manager_repository_impl.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/entities/translation.dart';

import 'translation_repository_impl_test.mocks.dart';

@GenerateMocks(
    [TranslationManagerLocalDataSource, TranslationManagerRemoteDataSource])
void main() {
  late TranslationManagerRepositoryImpl translationRepository;
  late MockTranslationLocalDataSource mockTranslationLocalDataSource;
  late MockTranslationRemoteDataSource mockTranslationRemoteDataSource;

  setUp(() {
    mockTranslationLocalDataSource = MockTranslationLocalDataSource();
    mockTranslationRemoteDataSource = MockTranslationRemoteDataSource();

    translationRepository = TranslationManagerRepositoryImpl(
      localDataSource: mockTranslationLocalDataSource,
      remoteDataSource: mockTranslationRemoteDataSource,
    );
  });

  group('get usfx translation from local device', () {
    const String id = 'eng-kjv';
    const translationModel = TranslationModel(
      name: 'King James Version + Apocrypha',
      abbreviation: 'eng-kjv',
      language: 'English',
      bookNames: {
        'GEN': Book(
          abbr: 'Gen',
          short: 'Genesis',
          long: 'The First Book of Moses, called Genesis',
          chapters: [
            Chapter(
              number: 1,
              paragraphs: [
                Paragraph(
                  title: '',
                  verses: [
                    Verse(
                      number: 1,
                      words: [
                        Word(text: 'In the'),
                        Word(text: 'beginning', scn: 'H7225'),
                        Word(text: 'God', scn: 'H0430'),
                        Word(text: 'created', scn: 'H1254'),
                        Word(text: 'the'),
                        Word(text: 'heaven', scn: 'H8064'),
                        Word(text: 'and', scn: 'H0853'),
                        Word(text: 'the'),
                        Word(text: 'earth', scn: 'H0776'),
                        Word(text: '.'),
                      ],
                    ),
                    Verse(
                      number: 2,
                      words: [
                        Word(text: 'And the'),
                        Word(text: 'earth', scn: 'H0776'),
                        Word(text: 'was', scn: 'H1961'),
                        Word(text: 'without'),
                        Word(text: 'form', scn: 'H8414'),
                        Word(text: ', and'),
                        Word(text: 'void', scn: 'H0922'),
                        Word(text: '; and'),
                        Word(text: 'darkness', scn: 'H2822'),
                        Word(text: 'was', italics: true),
                        Word(text: 'upon the'),
                        Word(text: 'face', scn: 'H6440'),
                        Word(text: 'of the'),
                        Word(text: 'deep', scn: 'H8415'),
                        Word(text: '. And the'),
                        Word(text: 'Spirit', scn: 'H7307'),
                        Word(text: 'of'),
                        Word(text: 'God', scn: 'H0430'),
                        Word(text: 'moved', scn: 'H7363'),
                        Word(text: 'upon', scn: 'H5921'),
                        Word(text: 'the'),
                        Word(text: 'face', scn: 'H6440'),
                        Word(text: 'of the'),
                        Word(text: 'waters', scn: 'H4325'),
                        Word(text: '.'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      },
    );
    const Translation translation = translationModel;

    test(
      'should return the choosen translation from local data source',
      () async {
        when(mockTranslationLocalDataSource.openLocalUsfxTranslation(id))
            .thenAnswer((_) async => translationModel);

        final result = await translationRepository.getLocalUsfxTranslation(id);

        verify(mockTranslationLocalDataSource.openLocalUsfxTranslation(id));
        expect(result, equals(Right(translation)));
      },
    );

    test(
      'should return no local data failure when there\'s no choosen translation from local data source',
      () async {
        when(mockTranslationLocalDataSource.openLocalUsfxTranslation(any))
            .thenThrow(NoLocalDataException());

        final result = await translationRepository.getLocalUsfxTranslation(id);

        verify(mockTranslationLocalDataSource.openLocalUsfxTranslation(id));
        expect(result, equals(Left(NoLocalDataFailure())));
      },
    );

    // test(
    //   'should return remote data when the call to remote data source is successful',
    //   () async {
    //     when(mockTranslationRemoteDataSource.downloadUsfxTranslation(any))
    //         .thenAnswer((_) async => translationModel);

    //     final result =
    //         await translationRepository.getUsfxTranslation(abbreviation);

    //     verify(mockTranslationRemoteDataSource
    //         .downloadUsfxTranslation(abbreviation));
    //     expect(result, equals(Right(translation)));
    //   },
    // );

    // test(
    //   'should return server failure when the call to remote data source is unsuccessful',
    //   () async {
    //     when(mockTranslationRemoteDataSource.downloadUsfxTranslation(any))
    //         .thenThrow(ServerException('error'));

    //     final result =
    //         await translationRepository.getUsfxTranslation(abbreviation);

    //     verify(mockTranslationRemoteDataSource
    //         .downloadUsfxTranslation(abbreviation));
    //     verifyZeroInteractions(mockTranslationLocalDataSource);
    //     expect(result, equals(Left(ServerFailure('error'))));
    //   },
    // );

    // test(
    //   'should save the translation when the call to remote data source is successful',
    //   () async {
    //     when(mockTranslationRemoteDataSource.downloadUsfxTranslation(any))
    //         .thenAnswer((_) async => translationModel);

    //     await translationRepository.getUsfxTranslation(abbreviation);

    //     verify(mockTranslationRemoteDataSource
    //         .downloadUsfxTranslation(abbreviation));
    //     verify(mockTranslationLocalDataSource
    //         .installTranslation(translationModel));
    //   },
    // );
  });

  group(
    'manage usfx translation from endpoint',
    () {
      test(
        'install usfx translation into local storage ',
        () {},
      );
      test(
        'install usfx translation into local storage ',
        () {},
      );
    },
  );
}
