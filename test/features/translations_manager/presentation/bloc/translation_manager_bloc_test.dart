// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/usecases/usecase.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/entities/translation.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/usecases/download_translation.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/usecases/get_local_translation.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/usecases/get_translations_info_list.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/usecases/install_translation.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/presentation/bloc/download_translations/dowloadable_translations_bloc.dart';

import 'translation_bloc_test.mocks.dart';

@GenerateMocks([
  DownloadTranslation,
  InstallUsfxTranslation,
  GetUsfxTranslation,
  GetTranslationsInfoList,
])
class MockTranslationBloc extends MockBloc<DownloadableTranslationsEvent,
    DownloadableTranslationsState> implements DownloadableTranslationsBloc {}

void main() {
  late DownloadableTranslationsBloc bloc;
  late MockDownloadUsfxTranslation mockDownloadUsfxTranslation;
  late MockInstallUsfxTranslation mockInstallUsfxTranslation;
  late MockGetUsfxTranslation mockGetUsfxTranslation;
  late MockGetTranslationsInfoList mockGetTranslationsInfoList;

  setUp(
    () {
      mockDownloadUsfxTranslation = MockDownloadUsfxTranslation();
      mockInstallUsfxTranslation = MockInstallUsfxTranslation();
      mockGetUsfxTranslation = MockGetUsfxTranslation();
      mockGetTranslationsInfoList = MockGetTranslationsInfoList();

      bloc = DownloadableTranslationsBloc(
        downloadUsfxTranslation: mockDownloadUsfxTranslation,
        installUsfxTranslation: mockInstallUsfxTranslation,
        getUsfxTranslation: mockGetUsfxTranslation,
        getTranslationsInfoList: mockGetTranslationsInfoList,
      );
    },
  );

  const id = 'eng-kjv';

  const translation = Translation(
    name: 'king james version',
    abbreviation: 'eng-kjv',
    language: 'english',
    bookNames: {},
  );

  provideDummy<Params>(Params(id: id));
  provideDummy<Either<Failure, Translation>>(Right(translation));
  provideDummy<Either<Failure, bool>>(Right(true));

  test(
    'initialState should be TranslationInitial',
    () {
      expect(bloc.state, equals(TManagerInitial()));
    },
  );

  group(
    'DownloadUsfxTranslation & InstallUsfxTranslation'
    '(as the latter is auto-triggered when download is success)',
    () {
      // test(
      //   'should get translation from download use case',
      //   () async {
      //     when(mockDownloadUsfxTranslation(any)).thenAnswer(
      //       (_) async => Right(translation),
      //     );

      //     bloc.add(DownloadTranslation(id));
      //     await Future.delayed(Duration.zero);
      //     verify(mockDownloadUsfxTranslation(Params(id: id)));
      //   },
      // );

      blocTest<DownloadableTranslationsBloc, DownloadableTranslationsState>(
        'emits [Downloading, DoneDownloading, Installing, DoneInstalling]'
        'when download && installation is successful.',
        build: () {
          when(mockDownloadUsfxTranslation(any)).thenAnswer(
            (_) async => Right(translation),
          );
          when(mockInstallUsfxTranslation(any)).thenAnswer(
            (_) async => Right(true),
          );

          return bloc;
        },
        act: (bloc) => bloc.add(TManagerDownloadPressed(id)),
        expect: () => <DownloadableTranslationsState>[
          TManagerDownloading(),
          TManagerDownloadSuccess(),
          TManagerInstallIning(),
          TManagerInstallSuccess(),
        ],
        verify: (_) {
          verify(mockDownloadUsfxTranslation(Params(id: id)));
        },
      );

      blocTest<DownloadableTranslationsBloc, DownloadableTranslationsState>(
        'emits [Downloading, Error] when download fails.',
        build: () {
          when(mockDownloadUsfxTranslation(any)).thenAnswer(
            (_) async => Left(ServerFailure()),
          );

          return bloc;
        },
        act: (bloc) => bloc.add(TManagerDownloadPressed(id)),
        expect: () => <DownloadableTranslationsState>[
          TManagerDownloading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ],
        verify: (_) {
          verify(mockDownloadUsfxTranslation(Params(id: id)));
          verifyNever(mockInstallUsfxTranslation(any));
        },
      );

      blocTest<DownloadableTranslationsBloc, DownloadableTranslationsState>(
        'emits [Downloading, DoneDownloading, Installing, Error]'
        'when download is successful && installation is not.',
        build: () {
          when(mockDownloadUsfxTranslation(any)).thenAnswer(
            (_) async => Right(translation),
          );
          when(mockInstallUsfxTranslation(any)).thenAnswer(
            (_) async => Left(InstallFailure()),
          );

          return bloc;
        },
        act: (bloc) => bloc.add(TManagerDownloadPressed(id)),
        expect: () => <DownloadableTranslationsState>[
          TManagerDownloading(),
          TManagerDownloadSuccess(),
          TManagerInstallIning(),
          Error(message: INSTALLATION_FAILURE_MESSAGE),
        ],
        verify: (_) {
          verify(mockDownloadUsfxTranslation(Params(id: id)));
        },
      );
    },
  );

  group(
    'getUsfxTranslation',
    () {
      // test(
      //   'usecase should return translation',
      //   () {
      //     when(mockGetUsfxTranslation(any))
      //         .thenAnswer((_) async => Right(translation));

      //     bloc.add(OpenTranslation(id));

      //     verify(mockGetUsfxTranslation(Params(id: id)));
      //   },
      // );

      blocTest<DownloadableTranslationsBloc, DownloadableTranslationsState>(
        'emits [Reading, DoneReading] when OpenTranslation is succesful.',
        build: () {
          when(mockGetUsfxTranslation(any)).thenAnswer(
            (_) async => Right(translation),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(TManagerOpenPressed(id)),
        expect: () => <DownloadableTranslationsState>[
          TManagerReading(),
          TManagerReadSuccess(translation: translation),
        ],
        verify: (_) {
          verify(mockGetUsfxTranslation(Params(id: id)));
        },
      );

      blocTest<DownloadableTranslationsBloc, DownloadableTranslationsState>(
        'emits [Reading, Error] when OpenTranslation fails.',
        build: () {
          when(mockGetUsfxTranslation(any)).thenAnswer(
            (_) async => Left(NoLocalDataFailure()),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(TManagerOpenPressed(id)),
        expect: () => <DownloadableTranslationsState>[
          TManagerReading(),
          Error(message: NO_LOCAL_DATA_FAILURE_MESSAGE),
        ],
        verify: (_) {
          verify(mockGetUsfxTranslation(Params(id: id)));
        },
      );
    },
  );
}
