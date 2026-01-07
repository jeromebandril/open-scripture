import 'package:flutter_test/flutter_test.dart';
import 'package:the_smyrna_bible_v2/core/utils/usfx_parser.dart';

void main() {
  test('getBible parses bible metadata correctly', () {
    const metadataXml = '''
    <DBLMetadata>
      <identification>
        <name>King James Version</name>
        <abbreviation>eng-kjv</abbreviation>
      </identification>
      <language>
        <iso>eng</iso>
        <name>English</name>
        <nameLocal>English</nameLocal>
      </language>
    </DBLMetadata>
    ''';

    const bibleXml = '<usfx></usfx>';

    final parser = UsfxParser(bibleXml, metadataXml);

    final bible = parser.getBible();

    expect(bible.bibleName, 'King James Version');
    expect(bible.abbreviation, 'eng-kjv');
    expect(bible.langIsoCode, 'eng');
  });

  test('getBooks parses book list from metadata', () {
    const metadataXml = '''
  <DBLMetadata>
    <bookNames>
      <book code="GEN">
        <long>Genesis</long>
        <short>Genesis</short>
        <abbr>Gen</abbr>
      </book>
      <book code="EXO">
        <long>Exodus</long>
        <short>Exodus</short>
        <abbr>Exo</abbr>
      </book>
    </bookNames>
  </DBLMetadata>
  ''';

    const bibleXml = '<usfx></usfx>';

    final parser = UsfxParser(bibleXml, metadataXml);
    final books = parser.getBooks();

    expect(books.length, 2);
    expect(books.first.osisId, 'GEN');
    expect(books.first.shortName, 'Genesis');
  });

  test('parses verse segments using v/ve milestones', () {
    const bibleXml = '''
  <usfx>
    <book id="GEN">
      <c id="1"/>
      <v id="6"/>
      And God said
      <ve/>
    </book>
  </usfx>
  ''';

    const metadataXml = '<DBLMetadata></DBLMetadata>';

    final parser = UsfxParser(bibleXml, metadataXml);
    final segments = parser.getVersesWithSpans();

    expect(segments.$1.length, 1);
    expect(segments.$1.first.ref.bookOsisId, 'GEN');
    expect(segments.$1.first.ref.chapter, 1);
    expect(segments.$1.first.ref.verseStart, 6);
    expect(segments.$1.first.textContent, contains('And God said'));
  });
}
