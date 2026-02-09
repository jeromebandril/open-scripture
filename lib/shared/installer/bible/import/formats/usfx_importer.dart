import 'package:open_scripture/shared/data/models/segment_key.dart';
import 'package:open_scripture/shared/data/models/verse_span_model.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';
import 'package:open_scripture/shared/installer/bible/import/bible_importer.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

import '../../../../domain/entities/bible_meta.dart';
import '../../../../domain/entities/book.dart';
import '../../../../domain/entities/verse_segment.dart';
import '../../../../domain/entities/verse_span.dart';
import '../../domain/models/canonical_bible_package.dart';
import '../../domain/models/payload_issue.dart';
import '../../source/packages/source_package.dart';

const Map<String, SpanType> usfxTagToSpanType = {
  // Basic character formatting
  'b': SpanType.bold,
  'i': SpanType.italic,
  'add': SpanType.add,
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

class UsfxImporter implements BibleImporter {
  static const int _canonicalSchemaVersion = 1;

  @override
  String get formatId => 'USFX';

  @override
  Future<bool> canImport(SourcePackage package) async {
    final entries = await package.listEntries();
    final paths = entries.map((e) => e.path.toLowerCase()).toList();

    final hasMetadata = paths.any((p) => p.endsWith('metadata.xml'));
    if (!hasMetadata) return false;

    final hasXml = paths.any((p) => p.endsWith('.xml'));
    return hasXml;
  }

  @override
  Future<CanonicalBiblePackage> importFrom(SourcePackage package) async {
    final issues = <PayloadIssue>[];

    // 1) Resolve entry paths
    final entryPaths =
        (await package.listEntries()).map((e) => e.path).toList();

    final metadataPath = _pickMetadataPath(entryPaths);
    if (metadataPath == null) {
      throw const FormatException('USFX: metadata.xml not found in package.');
    }

    final usfxPaths = _pickUsfxContentPaths(entryPaths);
    if (usfxPaths.isEmpty) {
      throw const FormatException(
          'USFX: no USFX content XML found in package.');
    }

    // 2) Parse metadata once
    final metadataContent = await package.readText(metadataPath);
    final metadataXml = XmlDocument.parse(metadataContent);

    // 3) Parse bible content (single file) OR merge multiple files
    // If multiple content files exist, we merge results.
    final allSegments = <VerseSegment>[];
    final allSpans = <VerseSpanModel>[];
    for (final path in usfxPaths) {
      final bibleContent = await package.readText(path);
      final bibleXml = XmlDocument.parse(bibleContent);

      final (segments, spans) = _parseVersesWithSpans(
        bibleXml: bibleXml,
        bookOsisIdFromUsfx: true,
      );
      allSegments.addAll(segments);
      allSpans.addAll(spans);
    }

    // 4) Build BibleMeta + Books from metadata
    final bibleMeta = _parseBibleMeta(metadataXml, issues);
    final books = _parseBooks(metadataXml, issues);

    // 5) Canonical header
    final packageId = await package.fingerprint();
    final header = CanonicalBibleHeader(
      packageId: packageId,
      sourceFormat: BibleSourceFormat.usfx,
      schemaVersion: _canonicalSchemaVersion,
      origin: package.displayName, // feature can override; see note below
      originDescription: 'Imported from ${package.displayName}',
    );

    final data = CanonicalBibleData(
      bibleMeta: bibleMeta,
      books: books,
      segments: allSegments,
      spans: allSpans,
    );

    return CanonicalBiblePackage(
      header: header,
      data: data,
      issues: issues,
    );
  }

  String? _pickMetadataPath(List<String> paths) {
    for (final p in paths) {
      if (p.toLowerCase().endsWith('metadata.xml')) return p;
    }
    return null;
  }

  List<String> _pickUsfxContentPaths(List<String> paths) {
    // Common names: usfx.xml, bible.xml, or any xml containing "usfx"
    // Start with likely candidates, then fallback to “all xml except metadata.xml”.
    final lower = paths.map((p) => p.toLowerCase()).toList();

    final candidates = <String>[];
    for (var i = 0; i < paths.length; i++) {
      final p = lower[i];
      if (!p.endsWith('.xml')) continue;
      if (p.endsWith('metadata.xml')) continue;

      if (p.contains('usfx') ||
          p.endsWith('usfx.xml') ||
          p.endsWith('bible.xml')) {
        candidates.add(paths[i]);
      }
    }

    if (candidates.isNotEmpty) return candidates;

    // Fallback: all xml except metadata.xml
    final fallback = <String>[];
    for (var i = 0; i < paths.length; i++) {
      final p = lower[i];
      if (p.endsWith('.xml') && !p.endsWith('metadata.xml')) {
        fallback.add(paths[i]);
      }
    }
    return fallback;
  }

  String _text(XmlDocument doc, String path) {
    final nodes = doc.xpath(path);
    if (nodes.isEmpty) return '';
    return nodes.first.innerText;
  }

  BibleMeta _parseBibleMeta(
      XmlDocument metadataXml, List<PayloadIssue> issues) {
    String required(String path, String pointer) {
      final v = _text(metadataXml, path).trim();
      if (v.isEmpty) {
        issues.add(PayloadIssue(
          severity: IssueSeverity.warning,
          code: 'missing_metadata',
          message: 'Missing metadata at $path',
          pointer: pointer,
        ));
      }
      return v;
    }

    final bibleName = required('//identification/name', 'BibleMeta.bibleName');
    final bibleNameLocal =
        required('//identification/nameLocal', 'BibleMeta.bibleNameLocal');
    final abbreviation =
        required('//identification/abbreviation', 'BibleMeta.abbreviation');
    final langEngName = required('//language/name', 'BibleMeta.langEngName');
    final langNativeName =
        required('//language/nameLocal', 'BibleMeta.langNativeName');
    final langIso = required('//language/iso', 'BibleMeta.langIsoCode');

    return BibleMeta(
      id: null,
      usfxId: abbreviation,
      bibleNameLocal: bibleNameLocal,
      bibleName: bibleName,
      abbreviation: abbreviation,
      langEngName: langEngName,
      langNativeName: langNativeName,
      langIsoCode: langIso,
    );
  }

  List<Book> _parseBooks(XmlDocument metadataXml, List<PayloadIssue> issues) {
    final bookNodes = metadataXml
        .findAllElements('bookNames')
        .expand((bn) => bn.findElements('book'))
        .toList(growable: false);

    if (bookNodes.isEmpty) {
      throw const FormatException(
          'USFX: No <bookNames>/<book> in metadata.xml');
    }

    final books = <Book>[];
    for (final b in bookNodes) {
      final code = b.getAttribute('code')?.trim();
      if (code == null || code.isEmpty) {
        issues.add(const PayloadIssue(
          severity: IssueSeverity.warning,
          code: 'book_missing_code',
          message: 'Book entry missing required attribute "code"',
          pointer: 'Books',
        ));
        continue;
      }

      String textOrEmpty(String tag) =>
          b.getElement(tag)?.innerText.trim() ?? '';

      final longName = textOrEmpty('long');
      final shortName = textOrEmpty('short');
      final abbr = b.getElement('abbr')?.innerText.trim();

      if (shortName.isEmpty || longName.isEmpty) {
        issues.add(PayloadIssue(
          severity: IssueSeverity.warning,
          code: 'book_missing_name',
          message: 'Book $code has empty <short> or <long> name',
          pointer: 'Book($code)',
        ));
      }

      books.add(Book(
        usfxId: code,
        longName: longName.isNotEmpty ? longName : shortName,
        shortName: shortName,
        abbr: (abbr == null || abbr.isEmpty) ? null : abbr,
      ));
    }

    return books;
  }

  (List<VerseSegment> segments, List<VerseSpanModel> spans)
      _parseVersesWithSpans({
    required XmlDocument bibleXml,
    required bool bookOsisIdFromUsfx,
  }) {
    final root = bibleXml.rootElement; // <usfx>
    final bookNodes = root.findElements("book").toList(growable: false);

    if (bookNodes.isEmpty) {
      throw const FormatException(
          'USFX: No <book> nodes found in content XML.');
    }

    final allSegments = <VerseSegment>[];
    final allSpans = <VerseSpanModel>[];

    for (final bookEl in bookNodes) {
      final bookId = bookEl.getAttribute('id')?.trim();
      if (bookId == null || bookId.isEmpty) {
        throw const FormatException(
            'USFX: <book> missing required attribute "id"');
      }
      final (segments, spans) = _parseVerseSegmentsForBook(bookEl, bookId);
      allSegments.addAll(segments);
      allSpans.addAll(spans);
    }

    return (allSegments, allSpans);
  }

  (List<VerseSegment> segments, List<VerseSpanModel> spans)
      _parseVerseSegmentsForBook(
    XmlElement bookEl,
    String bookUsfxId,
  ) {
    final segments = <VerseSegment>[];
    final spans = <VerseSpanModel>[];

    final buffer = StringBuffer();
    int? chapter;
    int? verse;
    bool inVerse = false;
    int segmentIndex = 0;
    bool lastWasSpace = false;

    void appendNormalized(String s) {
      for (final rune in s.runes) {
        final ch = String.fromCharCode(rune);
        final isWs = ch.trim().isEmpty;
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
          bookUsfxId: bookUsfxId,
          chapter: chapter!,
          verseStart: verse!,
        ),
        textContent: text,
        spans: const [],
      ));
    }

    bool isFootnoteTag(String name) =>
        name == 'f' || name == 'fr' || name == 'ft';
    bool isCrossReferenceTag(String name) =>
        name == 'x' || name == 'xo' || name == 'xt';
    bool isSpanTag(String tag) => tag == 'w' || tag == 'add' || tag == 'wj';

    String? spanPayload(XmlElement el) {
      if (el.name.local == 'w') return el.getAttribute('s');
      return null;
    }

    void walk(XmlNode node) {
      if (node is XmlElement) {
        final tag = node.name.local;

        if (isFootnoteTag(tag)) return;
        if (isCrossReferenceTag(tag)) return;

        if (tag == 'c') {
          final id = node.getAttribute('id');
          if (id != null) chapter = int.tryParse(id);
          return;
        }

        if (tag == 'v') {
          if (inVerse) flushVerse();
          final id = node.getAttribute('id');
          verse = id == null ? null : int.tryParse(id);
          inVerse = true;
          segmentIndex = 0;
          return;
        }

        if (tag == 've') {
          if (inVerse) flushVerse();
          inVerse = false;
          verse = null;
          return;
        }

        if (inVerse && isSpanTag(tag)) {
          final start = buffer.length;
          for (final child in node.children) {
            walk(child);
          }
          final end = buffer.length;

          if (end > start) {
            final spanType = usfxTagToSpanType[tag];
            if (spanType == null || chapter == null || verse == null) return;

            spans.add(VerseSpanModel(
              key: SegmentKey(
                bookUsfxId: bookUsfxId,
                chapter: chapter!,
                verse: verse!,
                segmentIndex: segmentIndex,
              ),
              startOffset: start,
              endOffset: end,
              type: spanType,
              payload: spanPayload(node),
            ));
          }
          return;
        }

        for (final child in node.children) {
          walk(child);
        }
        return;
      }

      if (node is XmlText) {
        if (inVerse) appendNormalized(node.value);
      }
    }

    for (final child in bookEl.children) {
      walk(child);
    }

    if (inVerse) flushVerse();

    return (segments, spans);
  }
}
