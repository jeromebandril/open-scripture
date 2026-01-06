import 'package:the_smyrna_bible_v2/core/domain/entities/bible_ref.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

import '../domain/entities/bible_meta.dart';
import '../domain/entities/book.dart';
import '../domain/entities/verse_segment.dart';

class UsfxParser {
  late final XmlDocument _bibleXml;
  late final XmlDocument _metadataXml;

  UsfxParser(String bibleContent, String metadataContent) {
    _bibleXml = XmlDocument.parse(bibleContent);
    _metadataXml = XmlDocument.parse(metadataContent);
  }

  String _text(String path) => _metadataXml.xpath(path).first.innerText;

  BibleMeta getBible() {
    final bibleName = _text('//identification/name');
    final abbreviation = _text('//identification/abbreviation');
    final langEngName = _text('//language/name');
    final langNativeName = _text('//language/nameLocal');
    final langAbbreviation = _text(('//language/iso'));

    return BibleMeta(
      id: null,
      extId: abbreviation,
      bibleName: bibleName,
      abbreviation: abbreviation,
      langEngName: langEngName,
      langNativeName: langNativeName,
      langIsoCode: langAbbreviation,
    );
  }

  List<Book> getBooks() {
    final bookNodes = _metadataXml.findAllElements('bookNames').expand(
          (bn) => bn.findElements('book'),
        );

    if (bookNodes.isEmpty) {
      throw const FormatException(
          'No <bookNames>/<book> entries found in metadata.xml');
    }

    return bookNodes.map((b) {
      final code = b.getAttribute('code');

      if (code == null || code.trim().isEmpty) {
        throw const FormatException(
            'Book entry missing required attribute "code"');
      }

      String textOrEmpty(String tag) =>
          b.getElement(tag)?.innerText.trim() ?? '';

      final longName = textOrEmpty('long');
      final shortName = textOrEmpty('short');
      final abbr = b.getElement('abbr')?.innerText.trim();

      // Required fields
      if (shortName.isEmpty) {
        throw FormatException('Book $code has empty <short> name');
      }
      if (longName.isEmpty) {
        throw FormatException('Book $code has empty <long> name');
      }

      return Book(
        osisId: code.trim(),
        longName: longName.isNotEmpty ? longName : shortName,
        shortName: shortName,
        abbr: (abbr == null || abbr.isEmpty) ? null : abbr,
      );
    }).toList(growable: false);
  }

  List<VerseSegment> getVerses() {
    final root = _bibleXml.rootElement; // <usfx>
    final bookNodes = root.findElements("book");

    if (bookNodes.isEmpty) {
      throw const FormatException(
          'No <bookNames>/<book> entries found in usfx.xml');
    }

    // walk trought the milestones
    return bookNodes.expand((b) {
      final code = b.getAttribute('id');

      if (code == null || code.trim().isEmpty) {
        throw const FormatException(
            'Book entry missing required attribute "code"');
      }

      return _parseVerseSegmentsForBook(b, code);
    }).toList();
  }

  List<VerseSegment> _parseVerseSegmentsForBook(
      XmlElement bookEl, String bookOsisId) {
    final segments = <VerseSegment>[];
    int? chapter;
    int? verse;
    bool inVerse = false;

    final buffer = StringBuffer();
    int segmentIndex = 0;

    void flushVerse() {
      final raw = buffer.toString();
      final text = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
      buffer.clear();

      if (chapter == null || verse == null) return;
      if (text.isEmpty) return;

      segments.add(VerseSegment(
        segmentIndex: segmentIndex++,
        paragraphStart: false,
        subtitle: null,
        ref: BibleRef(
          bookOsisId: bookOsisId,
          chapter: chapter!,
          verseStart: verse!,
        ),
        textContent: text,
        spans: [],
      ));
    }

    bool isFootnoteTag(String name) =>
        name == 'f' || name == 'fr' || name == 'ft';

    void walk(XmlNode node) {
      if (node is XmlElement) {
        final tag = node.name.local;

        // skip footnotes entirely
        if (isFootnoteTag(tag)) return;

        if (tag == 'c') {
          final id = node.getAttribute('id');
          if (id != null) chapter = int.tryParse(id);
          // chapter milestone doesn't necessarily flush verse
          return;
        }

        if (tag == 'v') {
          // starting a new verse milestone; if we were already inside one, flush first
          if (inVerse) flushVerse();

          final id = node.getAttribute('id');
          verse = id == null ? null : int.tryParse(id);
          inVerse = true;
          segmentIndex = 0;
          return; // <v/> is usually empty (milestone)
        }

        if (tag == 've') {
          // end verse milestone
          if (inVerse) flushVerse();
          inVerse = false;
          verse = null;
          return;
        }

        // default: traverse children (handles <w>, <add>, <nd>, etc.)
        for (final child in node.children) {
          walk(child);
        }
        return;
      }

      if (node is XmlText) {
        if (inVerse) {
          buffer.write(node.value);
        }
      }
    }

    // bookEl children usually include <c>, <v>, paragraphs, etc.
    for (final child in bookEl.children) {
      walk(child);
    }

    // safety flush
    if (inVerse) flushVerse();

    return segments;
  }
}
