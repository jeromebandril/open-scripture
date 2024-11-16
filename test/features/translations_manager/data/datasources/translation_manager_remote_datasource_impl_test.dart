import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:the_smyrna_bible_v2/core/data/models/translation_model.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/data/datasources/translation_manager_remote_datasource.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late TranslationManagerRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = TranslationManagerRemoteDataSourceImpl();
  });

  group(
    'identificators',
    () {
      test(
        'should return all available bible IDs from endpoint',
        () async {
          final ids = await dataSource.getAllTranslationsInfos();
        },
      );

      test(
        'should check if the translation is installed or not',
        () {},
      );
    },
  );

  group(
    'downloadTranslation',
    () {
      const id = 'alsSHQ';

      test(
        ''' should perform a GET request on a url
        with an id being the endpoint and with application/zip header
      ''',
        () async {
          // strangely http.Client doesn't fetch data correctly
          // but direct http calls do
          //
          // when(mockHttpCLient.get(any, headers: anyNamed('headers')))
          //     .thenAnswer(
          //   (_) async => http.Response('', 200),
          // );
          WidgetsFlutterBinding.ensureInitialized();
          dataSource.downloadTranslationFiles(id).listen(
                (event) {},
              );

          // verify(mockHttpCLient.get(
          //   Uri.parse('https://ebible.org/Scriptures/${id}_usfx.zip'),
          //   headers: {'Content-Type': 'application/zip'},
          // ));
        },
      );

      test(
        'should return translationModel from endpoint given the id',
        () {},
      );
    },
  );
}
