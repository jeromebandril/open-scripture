import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

import '../data/models/bible_model.dart';
import '../data/models/book_model.dart';
import '../data/models/verse_model.dart';

class UsfxParser {
  late final XmlDocument _bibleXml;
  late final XmlDocument _metadataXml;

  UsfxParser(String bibleContent, String metadataContent) {
    _bibleXml = XmlDocument.parse(bibleContent);
    _metadataXml = XmlDocument.parse(metadataContent);
  };

  BibleModel getBible() {
    final bibleName = _metadataXml.xpath('//identification/name').first.innerText;
    final abbreviation = _metadataXml.xpath('//identification/abbreviation').first.innerText;
    final langEngName = _metadataXml.xpath('//language/name').first.innerText;
    final langNativeName = _metadataXml.xpath('//language/nameLocal').first.innerText; 
    final langAbbreviation = _metadataXml.xpath('//language/iso').first.innerText; 

    return BibleModel(id: -1, bibleName: bibleName, abbreviation: abbreviation, langEngName: langEngName, langNativeName: langNativeName, langAbbreviation: langAbbreviation,);
  }

  //List<BookModel> getBooks() {}

  //List<VerseModel> getVerses() {}
}
