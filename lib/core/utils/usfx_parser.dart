import 'package:the_smyrna_bible_v2/core/data/models/segment_key.dart';
import 'package:the_smyrna_bible_v2/core/data/models/verse_span_model.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/bible_ref.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

import '../domain/entities/bible_meta.dart';
import '../domain/entities/book.dart';
import '../domain/entities/verse_segment.dart';
import '../domain/entities/verse_span.dart';

const Map<String, SpanType> usfxTagToSpanType = {
  // Basic character formatting
  'b': SpanType.bold,
  'i': SpanType.italic,
  'add': SpanType.italic,
  'u': SpanType.underline,
  'sc': SpanType.smallCaps,
  'sup': SpanType.superscript,

  // Jesus words / red letter
  'wj': SpanType.wordOfJesus,
  'rq': SpanType.redLetter,

  // Notes & references
  'f': SpanType.footnote,
  'x': SpanType.crossReference,
  'w': SpanType.strongWords,
  'ref': SpanType.reference,

  // Poetry / structure
  'q': SpanType.poetry,
  'q1': SpanType.poetry,
  'q2': SpanType.poetry,
  'q3': SpanType.poetry,
};

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
    final bibleNameLocal = _text('//identification/nameLocal');
    final abbreviation = _text('//identification/abbreviation');
    final langEngName = _text('//language/name');
    final langNativeName = _text('//language/nameLocal');
    final langAbbreviation = _text(('//language/iso'));

    return BibleMeta(
      id: null,
      usfxId: abbreviation,
      bibleNameLocal: bibleNameLocal,
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
        usfxId: code.trim(),
        longName: longName.isNotEmpty ? longName : shortName,
        shortName: shortName,
        abbr: (abbr == null || abbr.isEmpty) ? null : abbr,
      );
    }).toList(growable: false);
  }

  (List<VerseSegment> segments, List<VerseSpanModel> spans)
      getVersesWithSpans() {
    final root = _bibleXml.rootElement; // <usfx>
    final bookNodes = root.findElements("book");

    if (bookNodes.isEmpty) {
      throw const FormatException(
          'No <bookNames>/<book> entries found in usfx.xml');
    }

    final List<VerseSegment> allSegments = [];
    final List<VerseSpanModel> allSpans = [];

    for (final b in bookNodes) {
      final code = b.getAttribute('id');

      if (code == null || code.trim().isEmpty) {
        throw const FormatException(
            'Book entry missing required attribute "code"');
      }

      final result = _parseVerseSegmentsForBook(b, code);
      allSegments.addAll(result.$1);
      allSpans.addAll(result.$2);
    }

    return (allSegments, allSpans);
  }

  (List<VerseSegment> segments, List<VerseSpanModel> spans)
      _parseVerseSegmentsForBook(XmlElement bookEl, String bookOsisId) {
    final segments = <VerseSegment>[];
    final spans = <VerseSpanModel>[];
    final buffer = StringBuffer();
    int? chapter;
    int? verse;
    bool inVerse = false;
    int segmentIndex = 0;

    // helpter function to normalize the text nodes
    // before adding them in the string buffer
    bool lastWasSpace = false;
    void appendNormalized(String s) {
      for (final rune in s.runes) {
        final ch = String.fromCharCode(rune);
        final isWs = ch.trim().isEmpty; // whitespace
        if (isWs) {
          if (!lastWasSpace && buffer.isNotEmpty) {
            buffer.write(' ');
            lastWasSpace = true;
          }
        } else {
          buffer.write(ch);
          lastWasSpace = false;
        }
      }
    }

    // helper function to flush the VerseSegment
    // in the list after collecting the data
    // regarding it
    void flushVerse() {
      final text = buffer.toString().trim();
      buffer.clear();

      if (chapter == null || verse == null) return;
      if (text.isEmpty) return;
      segments.add(VerseSegment(
        segmentIndex: segmentIndex++,
        paragraphStart: false,
        subtitle: null,
        ref: BibleRef(
          bookUsfxId: bookOsisId,
          chapter: chapter!,
          verseStart: verse!,
        ),
        textContent: text,
        spans: [],
      ));
    }

    // helper functions for the tags to ignore
    bool isFootnoteTag(String name) =>
        name == 'f' || name == 'fr' || name == 'ft';

    bool isCrossReferenceTag(String name) =>
        name == 'x' || name == 'xo' || name == 'xt';

    bool isSpanTag(String tag) => tag == 'w' || tag == 'add' || tag == 'wj';

    String? spanPayload(XmlElement el) {
      // strong's number like <w s="H0430">
      if (el.name.local == 'w') return el.getAttribute('s');
      return null;
    }

    // recursive walk trought the nodes
    void walk(XmlNode node) {
      if (node is XmlElement) {
        final tag = node.name.local;

        // skip footnotes entirely
        if (isFootnoteTag(tag)) return;
        if (isCrossReferenceTag(tag)) return;

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

        // VerseSpans
        // If this element is a styling span, capture offsets around its children
        if (inVerse && isSpanTag(tag)) {
          final start = buffer.length;

          for (final child in node.children) {
            walk(child);
          }

          final end = buffer.length;
          if (end > start) {
            if (verse == null ||
                chapter == null ||
                usfxTagToSpanType[tag] == null) {
              throw Exception(
                  'ah null: $verse $chapter ${usfxTagToSpanType[tag]}');
            }
            spans.add(VerseSpanModel(
              key: SegmentKey(
                bookUsfxId: bookOsisId,
                chapter: chapter!,
                verse: verse!,
                segmentIndex: segmentIndex,
              ),
              startOffset: start,
              endOffset: end,
              type: usfxTagToSpanType[tag]!,
              payload: spanPayload(node),
            ));
          }
          return;
        }

        // default traversal: traverse children (handles <w>, <add>, <nd>, etc.)
        for (final child in node.children) {
          walk(child);
        }
        return;
      }

      if (node is XmlText) {
        if (inVerse) appendNormalized(node.value);
      }
    }

    // bookEl children usually include <c>, <v>, paragraphs, etc.
    for (final child in bookEl.children) {
      walk(child);
    }

    // safety flush
    if (inVerse) flushVerse();

    return (segments, spans);
  }
}
