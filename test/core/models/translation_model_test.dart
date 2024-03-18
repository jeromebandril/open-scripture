// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:the_smyrna_bible_v2/core/models/translation_model.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/entities/translation.dart';
import '../../fixtures/fixture_reader.dart';

void main() {
  final translationModel = TranslationModel(
    name: 'King James Version + Apocrypha',
    abbreviation: 'eng-kjv',
    language: 'English',
    bookNames: const {
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
                      Word(text: 'Teaching', scn: 'G1321', wordOfJesus: true),
                      Word(text: 'them', scn: 'G0846', wordOfJesus: true),
                      Word(text: 'to observe', scn: 'G5083', wordOfJesus: true),
                      Word(text: 'all things', scn: 'G3956', wordOfJesus: true),
                      Word(text: 'whatsoever', scn: 'G3745', wordOfJesus: true),
                      Word(
                          text: 'I have commanded',
                          scn: 'G1781',
                          wordOfJesus: true),
                      Word(text: 'you', scn: 'G5213', wordOfJesus: true),
                      Word(text: ':', wordOfJesus: true),
                      Word(text: 'and', scn: 'G2532', wordOfJesus: true),
                      Word(text: ',', wordOfJesus: true),
                      Word(text: 'lo', scn: 'G2400', wordOfJesus: true),
                      Word(text: ',', wordOfJesus: true),
                      Word(text: 'I', scn: 'G1473', wordOfJesus: true),
                      Word(text: 'am', scn: 'G1510', wordOfJesus: true),
                      Word(text: 'with', scn: 'G3326', wordOfJesus: true),
                      Word(text: 'you', scn: 'G5216', wordOfJesus: true),
                      Word(text: 'alway', scn: 'G3956', wordOfJesus: true),
                      Word(text: ',', wordOfJesus: true),
                      Word(text: 'even', italics: true, wordOfJesus: true),
                      Word(text: 'unto', scn: 'G2193', wordOfJesus: true),
                      Word(text: 'the end', scn: 'G4930', wordOfJesus: true),
                      Word(
                          text: 'of the world',
                          scn: 'G0165',
                          wordOfJesus: true),
                      Word(text: '.', wordOfJesus: true),
                      Word(text: 'Amen', scn: 'G0281'),
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

  test(
    'should be a subclass of Translation entity',
    () {
      expect(translationModel, isA<Translation>());
    },
  );

  group(
    'from usfx',
    () {
      test(
        'should get TranslatioModel from usfx file',
        () async {
          /*
          ** PROBLEM: a usfx file is technically a well formatted XML, however 
          ** it doesn't conform to standard heirarchy; Instead it sometimes uses closed tags
          ** called Milestones to mark the start of a chapter/verse and the end 
          ** of it. For example, the content of a verse is not enclose in a single tag
          ** \<v>, but there's a milestone <v> that marks the start and a milestone <ve/>
          ** that marks the end: consequentially these two tags are siblings (at the same level)
          ** with the verse content itself.
          **
          ** SOLUTION: after getting the paragraph, we need to read its content elements sequentially
          **
          */
          final documentMetadata = fixture('eng-kjvmetadata.xml');
          final documentSource = fixture('eng-kjv_usfx.xml');

          TranslationModel tm =
              TranslationModel.fromUSFX(documentMetadata, documentSource);

          expect(
            tm.bookNames['GEN'],
            translationModel.bookNames['GEN']!,
          );
          // expect(tm, translationModel);
        },
      );

      test('should return a valid USFX document', () async {
        translationModel.toUSFX();
      });
    },
  );
}
