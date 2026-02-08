import 'package:xml/xml.dart';

class OsisParser {
  late final XmlDocument _bibleXml;

  OsisParser(String bibleContent) {
    _bibleXml = XmlDocument.parse(bibleContent);
  }
}
