import 'package:open_scripture/core/engines/bible_compiler/domain/models/canonical_bible_package.dart';
import 'package:open_scripture/core/engines/bible_compiler/domain/models/payload_issue.dart';
import 'package:open_scripture/core/engines/bible_compiler/source/packages/source_package.dart';
import 'package:open_scripture/shared/domain/entities/bible_id.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/bible_importer.dart';
import 'package:open_scripture/shared/domain/entities/verse.dart';
import 'package:open_scripture/shared/domain/entities/bible_book.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/entities/localized_book.dart';

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
    return paths.any((p) => p.endsWith('.xml'));
  }

  @override
  Future<CanonicalBiblePackage> importFrom(SourcePackage package) async {
    final issues = <PayloadIssue>[];
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

    final metadataContent = await package.readText(metadataPath);
    final metadataXml = XmlDocument.parse(metadataContent);

    // Parse verse content across all content files
    final allVerses = <Verse>[];
    for (final path in usfxPaths) {
      final bibleContent = await package.readText(path);
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
        repoType: BibleRepositoryType.undefined,
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

    // Defer the heavy lifting to the stateful visitor class
    final visitor = _UsfxBookVisitor(bookId: bookId, bibleBook: bibleBook);
    return visitor.parse(bookEl);
  }
}

class _ActiveStyle {
  final SpanType type;
  final String? payload;
  _ActiveStyle(this.type, this.payload);
}

class _UsfxBookVisitor {
  final String bookId;
  final BibleBook bibleBook;

  int? _chapter;
  int? _verseNumber;
  bool _inVerse = false;
  int _segmentIndex = 0;

  // The style stack allows block elements (like <q> poetry) to span across multiple
  // verses and chapters without swallowing the <c> and <v> milestone tags.
  final List<_ActiveStyle> _styleStack = [];

  final List<VerseSpan> _currentSpans = [];
  final List<Verse> _verses = [];
  final StringBuffer _buffer = StringBuffer();
  bool _lastWasSpace = false;

  _UsfxBookVisitor({required this.bookId, required this.bibleBook});

  List<Verse> parse(XmlElement bookEl) {
    for (final child in bookEl.children) {
      _walk(child);
    }
    if (_inVerse) _flushVerse();
    return _verses;
  }

  void _walk(XmlNode node) {
    if (node is XmlElement) {
      final tag = node.name.local;

      if (_isFootnoteOrCrossRef(tag)) return;

      if (tag == 'c') {
        final id = node.getAttribute('id');
        if (id != null) {
          _chapter = int.tryParse(id);
          _segmentIndex = 0;
        }
        // Fall through to parse potential children if <c> is a container
      } else if (tag == 'v') {
        if (_inVerse) _flushVerse();
        final id = node.getAttribute('id');
        _verseNumber = id == null ? null : int.tryParse(id);
        _inVerse = true;
        _segmentIndex = 0;
        // Fall through to parse potential children if <v> is a container
      } else if (tag == 've') {
        if (_inVerse) _flushVerse();
        _inVerse = false;
        _verseNumber = null;
      } else if (usfxTagToSpanType.containsKey(tag)) {
        final spanType = usfxTagToSpanType[tag]!;
        final payload = tag == 'w' ? node.getAttribute('s') : null;

        // 1. Turn the style ON
        _pushStyle(_ActiveStyle(spanType, payload));

        // 2. Recurse normally (this prevents <c> and <v> from being swallowed)
        for (final child in node.children) {
          _walk(child);
        }

        // 3. Turn the style OFF
        _popStyle();

        return; // Children parsed, do not fall through to generic loop
      }

      // Generic element (e.g. <p> paragraphs) - recurse into children
      for (final child in node.children) {
        _walk(child);
      }
      return;
    }

    if (node is XmlText && _inVerse) {
      _appendNormalized(node.value);
    }
  }

  // ---------------------------------------------------------------------------
  // State Management
  // ---------------------------------------------------------------------------

  void _pushStyle(_ActiveStyle style) {
    _flushBuffer(); // Save existing text before the style changes
    _styleStack.add(style);
  }

  void _popStyle() {
    _flushBuffer(); // Save text with the old style before reverting
    if (_styleStack.isNotEmpty) {
      _styleStack.removeLast();
    }
  }

  void _appendNormalized(String s) {
    for (final rune in s.runes) {
      final ch = String.fromCharCode(rune);
      if (ch.trim().isEmpty) {
        // Allow a space if we haven't just appended one, and we are not at the very start of a verse
        if (!_lastWasSpace &&
            (_buffer.isNotEmpty || _currentSpans.isNotEmpty)) {
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

    if (text.isNotEmpty) {
      // Capture ALL active types currently in the stack
      final activeStyles = _styleStack.map((s) => s.type).toSet();

      // Capture the most relevant payload (e.g., the last one added)
      final activePayload = _styleStack.reversed
          .map((s) => s.payload)
          .firstWhere((p) => p != null, orElse: () => null);

      _currentSpans.add(VerseSpan(
        text: text,
        activeStyles: activeStyles,
        payload: activePayload,
      ));
    }
  }

  void _flushVerse() {
    _flushBuffer(); // Empty the text buffer into spans

    // Prevent empty verses from being added
    if (_chapter == null || _verseNumber == null || _currentSpans.isEmpty)
      return;

    _verses.add(Verse(
      translationId: bookId,
      ref: BibleRef(
          book: bibleBook, chapter: _chapter!, verseStart: _verseNumber),
      segments: [
        VerseSegment(
          segmentIndex: _segmentIndex++,
          spans: List.unmodifiable(_currentSpans),
        ),
      ],
    ));

    _currentSpans.clear();
    _lastWasSpace = false; // Reset space tracker for new verse
  }

  bool _isFootnoteOrCrossRef(String name) =>
      name == 'f' ||
      name == 'fr' ||
      name == 'ft' ||
      name == 'x' ||
      name == 'xo' ||
      name == 'xt';
}
