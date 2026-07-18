import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

import '../../../../../shared/domain/entities/bible_book.dart';
import '../../../../../shared/domain/entities/bible_id.dart';
import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/entities/bible_translation.dart';
import '../../../../../shared/domain/entities/localized_book.dart';
import '../../../../../shared/domain/entities/verse.dart';
import '../../../../../shared/enums/bible_repository_type.dart';
import '../../domain/models/canonical_bible_package.dart';
import '../../domain/models/payload_issue.dart';
import '../../source/packages/source_package.dart';
import '../bible_importer.dart';

const Map<String, SpanType> usfxTagToSpanType = {
  // Basic character formatting
  'b': SpanType.bold,
  'i': SpanType.italic,
  'add': SpanType.added,
  'u': SpanType.underline,
  'sc': SpanType.smallCaps,
  'sup': SpanType.superscript,

  // Jesus words / red letter
  'wj': SpanType.redLetter,
  'rq': SpanType.redLetter,

  // Notes & references
  'f': SpanType.footnote,
  'x': SpanType.crossReference,
  'w': SpanType.strongs,
  'ref': SpanType.reference,

  // Poetry / structure
  'q': SpanType.poetry,
  'q1': SpanType.poetry,
  'q2': SpanType.poetry,
  'q3': SpanType.poetry,
};

/// Tags whose whole subtree is excluded from verse text. Footnotes and
/// cross references carry their own text (like "Heb: ...") that would
/// otherwise leak into the plain verse text if we treated them as spans.
const Set<String> _excludedFromVerseText = {'f', 'fr', 'ft', 'x', 'xo', 'xt'};

class UsfxImporter implements BibleImporter {
  static const int _canonicalSchemaVersion = 1;

  @override
  String get formatId => 'USFX';

  @override
  Future<bool> canImport(SourcePackage package) async {
    // This is USFX is in zip format
    // I've seen some as standalone files (which are not supported by this importer)
    if (package is! ContainerPackage) return false;
    final entries = package.listEntries();
    final paths = entries.map((e) => e.path.toLowerCase()).toList();
    final hasMetadata = paths.any((p) => p.endsWith('metadata.xml'));
    if (!hasMetadata) return false;
    return paths.any((p) => p.endsWith('.xml'));
  }

  @override
  Future<CanonicalBiblePackage> importFrom(SourcePackage package) async {
    package as ContainerPackage;

    final issues = <PayloadIssue>[];
    final entryPaths = (package.listEntries()).map((e) => e.path).toList();

    final metadataPath = _pickMetadataPath(entryPaths);
    if (metadataPath == null) {
      throw const FormatException('USFX: metadata.xml not found in package.');
    }

    final usfxPaths = _pickUsfxContentPaths(entryPaths);
    if (usfxPaths.isEmpty) {
      throw const FormatException(
          'USFX: no USFX content XML found in package.');
    }

    final metadataContent = await (await package.open(metadataPath)).readText();
    final metadataXml = XmlDocument.parse(metadataContent);

    // Parse verse content across all content files
    final allVerses = <Verse>[];
    for (final path in usfxPaths) {
      final bibleContent = await (await package.open(path)).readText();
      final bibleXml = XmlDocument.parse(bibleContent);
      allVerses.addAll(_parseVerses(bibleXml));
    }

    final translation = _parseBibleTranslation(metadataXml, issues);
    final localizedBooks = _parseLocalizedBooks(metadataXml, issues);
    final packageId = await package.fingerprint();

    return CanonicalBiblePackage(
      header: CanonicalBibleHeader(
        packageId: packageId,
        sourceFormat: BibleSourceFormat.usfx,
        schemaVersion: _canonicalSchemaVersion,
        origin: package.displayName,
        originDescription: 'Imported from ${package.displayName}',
      ),
      data: CanonicalBibleData(
        bibleTranslation: translation,
        books: localizedBooks,
        verses: allVerses,
      ),
      issues: issues,
    );
  }

  // ---------------------------------------------------------------------------
  // Path resolution
  // ---------------------------------------------------------------------------

  String? _pickMetadataPath(List<String> paths) {
    for (final p in paths) {
      if (p.toLowerCase().endsWith('metadata.xml')) return p;
    }
    return null;
  }

  List<String> _pickUsfxContentPaths(List<String> paths) {
    final lower = paths.map((p) => p.toLowerCase()).toList();
    final candidates = <String>[];

    for (var i = 0; i < paths.length; i++) {
      final p = lower[i];
      if (!p.endsWith('.xml') || p.endsWith('metadata.xml')) continue;

      if (p.contains('usfx') ||
          p.endsWith('usfx.xml') ||
          p.endsWith('bible.xml')) {
        candidates.add(paths[i]);
      }
    }

    if (candidates.isNotEmpty) return candidates;

    // Fallback: all xml except metadata
    return [
      for (var i = 0; i < paths.length; i++)
        if (lower[i].endsWith('.xml') && !lower[i].endsWith('metadata.xml'))
          paths[i]
    ];
  }

  // ---------------------------------------------------------------------------
  // Metadata parsing -> BibleTranslation
  // ---------------------------------------------------------------------------

  String _text(XmlDocument doc, String path) {
    final nodes = doc.xpath(path);
    return nodes.isEmpty ? '' : nodes.first.innerText;
  }

  BibleTranslation _parseBibleTranslation(
      XmlDocument metadataXml, List<PayloadIssue> issues) {
    String required(String xpath, String pointer) {
      final v = _text(metadataXml, xpath).trim();
      if (v.isEmpty) {
        issues.add(PayloadIssue(
          severity: IssueSeverity.warning,
          code: 'missing_metadata',
          message: 'Missing metadata at $xpath',
          pointer: pointer,
        ));
      }
      return v;
    }

    final abbreviation = required(
        '//identification/abbreviationLocal', 'BibleTranslation.abbreviation');

    return BibleTranslation(
      localId: null,
      extId: BibleId(
        repoType: BibleRepositoryType.localDatabase,
        externalId: abbreviation,
      ),
      name: required('//identification/name', 'BibleTranslation.name'),
      localName:
          required('//identification/nameLocal', 'BibleTranslation.localName'),
      abbreviation: abbreviation,
      langIsoCode: required('//language/iso', 'BibleTranslation.langIsoCode'),
      langEngName: required('//language/name', 'BibleTranslation.langEngName'),
      langNativeName:
          required('//language/nameLocal', 'BibleTranslation.langNativeName'),
      originSource: null,
      originFormat: formatId,
      description: required(
          '//identification/description', 'BibleTranslation.description'),
      copyright:
          required('//copyright/statement', 'BibleTranslation.copyright'),
    );
  }

  // ---------------------------------------------------------------------------
  // Metadata parsing -> LocalizedBook list
  // ---------------------------------------------------------------------------

  List<LocalizedBook> _parseLocalizedBooks(
      XmlDocument metadataXml, List<PayloadIssue> issues) {
    final bookNodes = metadataXml
        .findAllElements('bookNames')
        .expand((bn) => bn.findElements('book'))
        .toList(growable: false);

    if (bookNodes.isEmpty) {
      throw const FormatException(
          'USFX: No <bookNames>/<book> in metadata.xml');
    }

    final books = <LocalizedBook>[];

    for (final b in bookNodes) {
      final code = b.getAttribute('code')?.trim();
      if (code == null || code.isEmpty) {
        issues.add(const PayloadIssue(
          severity: IssueSeverity.warning,
          code: 'book_missing_code',
          message: 'Book entry missing required attribute "code"',
          pointer: 'LocalizedBook',
        ));
        continue;
      }

      final bibleBook = BibleBook.fromProgrammaticId(code);
      if (bibleBook == null) {
        issues.add(PayloadIssue(
          severity: IssueSeverity.warning,
          code: 'book_unknown_code',
          message: 'Unknown book code "$code" - skipping',
          pointer: 'LocalizedBook($code)',
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
          pointer: 'LocalizedBook($code)',
        ));
      }

      books.add(LocalizedBook(
        book: bibleBook,
        longName: longName.isNotEmpty ? longName : shortName,
        shortName: shortName,
        abbreviation: (abbr == null || abbr.isEmpty) ? null : abbr,
      ));
    }

    return books;
  }

  // ---------------------------------------------------------------------------
  // Bible content parsing -> List<Verse>
  // ---------------------------------------------------------------------------

  List<Verse> _parseVerses(XmlDocument bibleXml) {
    final root = bibleXml.rootElement;
    final bookNodes = root.findElements('book').toList(growable: false);

    if (bookNodes.isEmpty) {
      throw const FormatException(
          'USFX: No <book> nodes found in content XML.');
    }

    return [
      for (final bookEl in bookNodes) ..._parseVersesForBook(bookEl),
    ];
  }

  List<Verse> _parseVersesForBook(XmlElement bookEl) {
    final bookId = bookEl.getAttribute('id')?.trim();
    if (bookId == null || bookId.isEmpty) {
      throw const FormatException(
          'USFX: <book> missing required attribute "id"');
    }

    final bibleBook = BibleBook.fromProgrammaticId(bookId);
    if (bibleBook == null) return []; // Unknown book - skip silently

    final visitor = _UsfxBookVisitor(bookId: bookId, bibleBook: bibleBook);
    return visitor.parse(bookEl);
  }
}

/// A style that is currently open while walking the tree (e.g. we are
/// inside a <w> or <i> element and have not reached its closing tag yet).
class _ActiveStyle {
  final SpanType type;
  final String? payload;
  _ActiveStyle(this.type, this.payload);
}

/// Walks a single <book> element and turns it into a flat list of [Verse]
/// objects.
///
/// USFX marks chapters and verses as empty "milestone" elements (<c/>,
/// <v/>, <ve/>) rather than as containers, while paragraphs (<p>) and
/// character styles (<i>, <w>, ...) are real containers. A style can span
/// across a <c> or <v> milestone without closing, and a <p> can (rarely)
/// open in the middle of a verse. That mix is why this is a small stateful
/// visitor rather than a plain recursive-descent parse.
class _UsfxBookVisitor {
  final String bookId;
  final BibleBook bibleBook;

  _UsfxBookVisitor({required this.bookId, required this.bibleBook});

  int? _chapter;
  int? _verseNumber;
  bool _inVerse = false;

  // Set by <p>, consumed by the next segment that gets closed. This is how
  // a paragraph break turns into VerseSegment.isParagraphStart.
  bool _pendingParagraphStart = false;

  // Segments completed so far for the verse currently being built. A verse
  // normally ends up with exactly one segment; it only gets more than one
  // if a <p> opens mid-verse.
  final List<VerseSegment> _verseSegments = [];
  int _segmentIndex = 0;

  // Styles currently open, outermost first.
  final List<_ActiveStyle> _styleStack = [];

  final List<VerseSpan> _currentSpans = [];
  final StringBuffer _buffer = StringBuffer();
  bool _lastWasSpace = false;

  final List<Verse> _verses = [];

  List<Verse> parse(XmlElement bookEl) {
    for (final child in bookEl.children) {
      _walk(child);
    }
    if (_inVerse) _flushVerse();
    return _verses;
  }

  void _walk(XmlNode node) {
    if (node is XmlText) {
      if (_inVerse) _appendText(node.value);
      return;
    }

    if (node is! XmlElement) return;

    final tag = node.name.local;
    if (_excludedFromVerseText.contains(tag)) return;

    if (tag == 'c') {
      _handleChapterMarker(node);
    } else if (tag == 'v') {
      _handleVerseStart(node);
    } else if (tag == 've') {
      _handleVerseEnd();
    } else if (tag == 'p') {
      _handleParagraphStart();
    } else if (usfxTagToSpanType.containsKey(tag)) {
      _handleStyledElement(node, usfxTagToSpanType[tag]!);
      return; // children already walked inside the style push/pop
    }

    // Generic containers (<p>, <c> if it ever has children, etc.) and
    // anything else we don't specifically handle: just recurse.
    for (final child in node.children) {
      _walk(child);
    }
  }

  // ---------------------------------------------------------------------
  // Milestone handlers
  // ---------------------------------------------------------------------

  void _handleChapterMarker(XmlElement node) {
    final id = node.getAttribute('id');
    if (id != null) _chapter = int.tryParse(id);
  }

  void _handleVerseStart(XmlElement node) {
    if (_inVerse) _flushVerse();
    final id = node.getAttribute('id');
    _verseNumber = id == null ? null : int.tryParse(id);
    _inVerse = true;
  }

  void _handleVerseEnd() {
    if (_inVerse) _flushVerse();
    _inVerse = false;
    _verseNumber = null;
  }

  /// A <p> marks the start of a new paragraph. It does not immediately
  /// produce a segment: it closes whatever segment was already open (so
  /// text written before this point keeps its own paragraph flag) and
  /// flags the next bit of text as the start of a new paragraph.
  void _handleParagraphStart() {
    _closeSegment();
    _pendingParagraphStart = true;
  }

  void _handleStyledElement(XmlElement node, SpanType spanType) {
    final payload = node.name.local == 'w' ? node.getAttribute('s') : null;

    _pushStyle(_ActiveStyle(spanType, payload));
    for (final child in node.children) {
      _walk(child);
    }
    _popStyle();
  }

  // ---------------------------------------------------------------------
  // Style stack
  // ---------------------------------------------------------------------

  void _pushStyle(_ActiveStyle style) {
    _flushBuffer(); // text seen so far keeps the styles active before this one
    _styleStack.add(style);
  }

  void _popStyle() {
    _flushBuffer(); // text seen under this style should still carry it
    if (_styleStack.isNotEmpty) _styleStack.removeLast();
  }

  // ---------------------------------------------------------------------
  // Text buffering
  // ---------------------------------------------------------------------

  void _appendText(String s) {
    for (final rune in s.runes) {
      final ch = String.fromCharCode(rune);
      if (ch.trim().isEmpty) {
        // Collapse whitespace runs to a single space, and drop leading
        // whitespace at the very start of a verse or segment.
        final atStart = _buffer.isEmpty && _currentSpans.isEmpty;
        if (!_lastWasSpace && !atStart) {
          _buffer.write(' ');
          _lastWasSpace = true;
        }
      } else {
        _buffer.write(ch);
        _lastWasSpace = false;
      }
    }
  }

  void _flushBuffer() {
    final text = _buffer.toString();
    _buffer.clear();
    if (text.isEmpty) return;

    final activeStyles = _styleStack.map((s) => s.type).toSet();
    final activePayload = _styleStack.reversed
        .map((s) => s.payload)
        .firstWhere((p) => p != null, orElse: () => null);

    _currentSpans.add(VerseSpan(
      text: text,
      activeStyles: activeStyles,
      payload: activePayload,
    ));
  }

  // ---------------------------------------------------------------------
  // Segment / verse assembly
  // ---------------------------------------------------------------------

  /// Turns whatever text is currently buffered into a completed
  /// [VerseSegment], tagged with the paragraph flag pending since the last
  /// <p>. Safe to call speculatively: it is a no-op if there is nothing to
  /// flush, and the paragraph flag is only consumed once it is actually
  /// attached to a segment.
  void _closeSegment() {
    _flushBuffer();
    if (_currentSpans.isEmpty) return;

    _verseSegments.add(VerseSegment(
      segmentIndex: _segmentIndex++,
      isParagraphStart: _pendingParagraphStart,
      spans: List.unmodifiable(_currentSpans),
    ));
    _currentSpans.clear();
    _pendingParagraphStart = false;
    _lastWasSpace = false;
  }

  void _flushVerse() {
    _closeSegment();

    final hasContent =
        _chapter != null && _verseNumber != null && _verseSegments.isNotEmpty;

    if (hasContent) {
      _verses.add(Verse(
        translationId: bookId,
        ref: BibleRef(
          book: bibleBook,
          chapter: _chapter!,
          verseStart: _verseNumber,
        ),
        segments: List.unmodifiable(_verseSegments),
      ));
    }

    _verseSegments.clear();
    _segmentIndex = 0;
  }
}
