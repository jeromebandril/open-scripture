import 'package:open_scripture/core/engines/bible_compiler/domain/models/canonical_bible_package.dart';
import 'package:open_scripture/core/engines/bible_compiler/domain/models/payload_issue.dart';
import 'package:open_scripture/core/engines/bible_compiler/source/packages/source_package.dart';
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
      final verses = _parseVerses(bibleXml);
      allVerses.addAll(verses);
    }

    final translation = _parseBibleTranslation(metadataXml, issues);
    final localizedBooks = _parseLocalizedBooks(metadataXml, issues);

    final packageId = await package.fingerprint();
    final header = CanonicalBibleHeader(
      packageId: packageId,
      sourceFormat: BibleSourceFormat.usfx,
      schemaVersion: _canonicalSchemaVersion,
      origin: package.displayName,
      originDescription: 'Imported from ${package.displayName}',
    );

    final data = CanonicalBibleData(
      bibleTranslation: translation,
      books: localizedBooks,
      verses: allVerses,
    );

    return CanonicalBiblePackage(
      header: header,
      data: data,
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
      if (!p.endsWith('.xml')) continue;
      if (p.endsWith('metadata.xml')) continue;
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

    final name = required('//identification/name', 'BibleTranslation.name');
    final nameLocal =
        required('//identification/nameLocal', 'BibleTranslation.localName');
    final abbreviation = required(
        '//identification/abbreviationLocal', 'BibleTranslation.abbreviation');
    final langEngName =
        required('//language/name', 'BibleTranslation.langEngName');
    final langNativeName =
        required('//language/nameLocal', 'BibleTranslation.langNativeName');
    final langIso = required('//language/iso', 'BibleTranslation.langIsoCode');
    final description = required(
        '//identification/description', 'BibleTranslation.description');
    final copyright =
        required('//copyright/statement', 'BibleTranslation.copyright');

    return BibleTranslation(
      localId: null,
      extId: abbreviation,
      name: name,
      localName: nameLocal,
      abbreviation: abbreviation,
      langIsoCode: langIso,
      langEngName: langEngName,
      langNativeName: langNativeName,
      originSource: null,
      originFormat: formatId,
      description: description,
      copyright: copyright,
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
    if (bibleBook == null) {
      // Unknown book - skip silently (caller can add an issue if desired)
      return [];
    }

    // Accumulator for the current verse being built
    int? chapter;
    int? verseNumber;
    bool inVerse = false;
    int segmentIndex = 0;

    // Per-segment accumulators
    final List<VerseSpan> currentSpans = [];

    // Completed verses
    final verses = <Verse>[];

    // Inline text buffer for the current span/normal run
    final buffer = StringBuffer();
    bool lastWasSpace = false;

    void appendNormalized(String s) {
      for (final rune in s.runes) {
        final ch = String.fromCharCode(rune);
        final isWs = ch.trim().isEmpty;
        if (isWs) {
          // Also allow a space if spans were already emitted before this text node
          if (!lastWasSpace && (buffer.isNotEmpty || currentSpans.isNotEmpty)) {
            buffer.write(' ');
            lastWasSpace = true;
          }
        } else {
          buffer.write(ch);
          lastWasSpace = false;
        }
      }
    }

    void flushNormalRun() {
      final text = buffer.toString();
      buffer.clear();
      lastWasSpace = false;
      if (text.isNotEmpty) {
        currentSpans.add(VerseSpan(type: SpanType.normal, text: text));
      }
    }

    void flushVerse() {
      flushNormalRun();

      if (chapter == null || verseNumber == null) return;
      if (currentSpans.isEmpty) return;

      final ref = BibleRef(
        book: bibleBook,
        chapter: chapter!,
        verseStart: verseNumber,
      );

      verses.add(Verse(
        translationId: bookId, // placeholder - caller stamps the real extId
        ref: ref,
        segments: [
          VerseSegment(
            segmentIndex: segmentIndex++,
            spans: List.unmodifiable(currentSpans),
          ),
        ],
      ));

      currentSpans.clear();
    }

    bool isFootnoteOrCrossRef(String name) =>
        name == 'f' ||
        name == 'fr' ||
        name == 'ft' ||
        name == 'x' ||
        name == 'xo' ||
        name == 'xt';

    bool isSpanTag(String tag) => usfxTagToSpanType.containsKey(tag);

    String? spanPayload(XmlElement el) {
      if (el.name.local == 'w') return el.getAttribute('s');
      return null;
    }

    void walk(XmlNode node) {
      if (node is XmlElement) {
        final tag = node.name.local;

        // Always skip footnote/cross-reference subtrees
        if (isFootnoteOrCrossRef(tag)) return;

        if (tag == 'c') {
          final id = node.getAttribute('id');
          if (id != null) {
            chapter = int.tryParse(id);
            segmentIndex = 0;
          }
          return;
        }

        if (tag == 'v') {
          if (inVerse) flushVerse();
          final id = node.getAttribute('id');
          verseNumber = id == null ? null : int.tryParse(id);
          inVerse = true;
          segmentIndex = 0;
          return;
        }

        if (tag == 've') {
          if (inVerse) flushVerse();
          inVerse = false;
          verseNumber = null;
          return;
        }

        if (inVerse && isSpanTag(tag)) {
          // Flush any plain text accumulated before this span
          flushNormalRun();

          // Collect the text content of this element's subtree
          final spanBuffer = StringBuffer();
          void collectText(XmlNode n) {
            if (n is XmlText) {
              spanBuffer.write(n.value);
            } else if (n is XmlElement && !isFootnoteOrCrossRef(n.name.local)) {
              for (final child in n.children) {
                collectText(child);
              }
            }
          }

          for (final child in node.children) {
            collectText(child);
          }

          // Collapse ALL internal whitespace sequences, not just leading/trailing
          final spanText =
              spanBuffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();

          if (spanText.isNotEmpty) {
            final spanType = usfxTagToSpanType[tag]!;
            currentSpans.add(VerseSpan(
              type: spanType,
              text: spanText,
              payload: spanPayload(node),
            ));
            // Reset space tracking after a span
            lastWasSpace = spanText.endsWith(' ');
          }
          return;
        }

        // Generic element - recurse into children
        for (final child in node.children) {
          walk(child);
        }
        return;
      }

      if (node is XmlText && inVerse) {
        appendNormalized(node.value);
      }
    }

    for (final child in bookEl.children) {
      walk(child);
    }

    if (inVerse) flushVerse();

    return verses;
  }
}
