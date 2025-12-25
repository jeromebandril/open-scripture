import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

import '../domain/entities/bible_meta.dart';

class UsfxParser {
  late final XmlDocument _bibleXml;
  late final XmlDocument _metadataXml;

  UsfxParser(String bibleContent, String metadataContent) {
    _bibleXml = XmlDocument.parse(bibleContent);
    _metadataXml = XmlDocument.parse(metadataContent);
  }

  BibleMeta getBible() {
    String _text(String path) => _metadataXml.xpath(path).first.innerText;

    final bibleName = _text('//identification/name');
    final abbreviation = _text('//identification/abbreviation');
    final langEngName = _text('//language/name');
    final langNativeName = _text('//language/nameLocal');
    final langAbbreviation = _text(('//language/iso'));

    return BibleMeta(
      id: -1,
      extId: abbreviation,
      bibleName: bibleName,
      abbreviation: abbreviation,
      langEngName: langEngName,
      langNativeName: langNativeName,
      langIsoCode: langAbbreviation,
    );
  }

  //List<BookModel> getBooks() {}

  //List<VerseModel> getVerses() {}
}
