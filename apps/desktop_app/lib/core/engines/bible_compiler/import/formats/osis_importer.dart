import 'package:open_scripture/core/engines/bible_compiler/domain/models/canonical_bible_package.dart';
import 'package:open_scripture/core/engines/bible_compiler/domain/models/payload_issue.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/bible_importer.dart';
import 'package:open_scripture/core/engines/bible_compiler/source/packages/source_package.dart';
import 'package:open_scripture/shared/domain/entities/bible_book.dart';
import 'package:open_scripture/shared/domain/entities/bible_id.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/entities/localized_book.dart';
import 'package:open_scripture/shared/domain/entities/verse.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

// helper class
class _ActiveStyle {
  final SpanType type;
  final String? payload;
  _ActiveStyle(this.type, this.payload);
}

final class OsisImporter implements BibleImporter {
  static const int _canonicalSchemaVersion = 1;

  @override
  String get formatId => 'OSIS';

  @override
  Future<bool> canImport(SourcePackage package) async {
    if (!await package.exists('main')) return false;
    final text = await package.readText('main');
    return text.contains('<osis') && text.contains('OSIS/namespace');
  }

  @override
  Future<CanonicalBiblePackage> importFrom(SourcePackage package) async {
    final issues = <PayloadIssue>[];

    final xmlText = await package.readText('main');
    final doc = XmlDocument.parse(xmlText);

    final translation = _parseBibleTranslation(doc, issues);
    final (books, verses) =
        _parseBooksAndVerses(doc, issues, translation.extId.externalId);

    final packageId = await package.fingerprint();
    final header = CanonicalBibleHeader(
      packageId: packageId,
      sourceFormat: BibleSourceFormat.osis,
      schemaVersion: _canonicalSchemaVersion,
      origin: package.displayName,
      originDescription: 'Imported from ${package.displayName}',
    );

    return CanonicalBiblePackage(
      header: header,
      data: CanonicalBibleData(
        bibleTranslation: translation,
        books: books,
        verses: verses,
      ),
      issues: issues,
    );
  }

  // ---------------------------------------------------------------------------
  // Metadata → BibleTranslation
  // ---------------------------------------------------------------------------

  String _firstText(XmlDocument doc, String xpath) {
    final nodes = doc.xpath(xpath);
    return nodes.isEmpty ? '' : nodes.first.innerText.trim();
  }

  BibleTranslation _parseBibleTranslation(
    XmlDocument doc,
    List<PayloadIssue> issues,
  ) {
    String get(String xpath, String pointer) {
      final v = _firstText(doc, xpath);
      if (v.isEmpty) {
        issues.add(PayloadIssue(
          severity: IssueSeverity.warning,
          code: 'missing_metadata',
          message: 'Missing OSIS metadata at $xpath',
          pointer: pointer,
        ));
      }
      return v;
    }

    const workBase = "//*[local-name()='work'][@osisWork][1]";

    final title =
        get("$workBase/*[local-name()='title'][1]", 'BibleTranslation.name');
    final identifier = get(
        "$workBase/*[local-name()='identifier'][1]", 'BibleTranslation.extId');
    final lang = get("$workBase/*[local-name()='language'][1]",
        'BibleTranslation.langIsoCode');
    final desc = _firstText(doc, "$workBase/*[local-name()='description'][1]");
    final rights = _firstText(doc, "$workBase/*[local-name()='rights'][1]");

    final safeTitle = title.isEmpty ? 'Untitled' : title;
    final safeId = identifier.isEmpty ? safeTitle : identifier;

    return BibleTranslation(
      localId: null,
      extId: BibleId(
        repoType: BibleRepositoryType.localDatabase,
        externalId: safeId,
      ),
      name: safeTitle,
      localName: safeTitle,
      abbreviation: safeId,
      langIsoCode: lang,
      langEngName: lang,
      langNativeName: lang,
      originSource: null,
      originFormat: formatId,
      description: desc,
      copyright: rights,
    );
  }

  // ---------------------------------------------------------------------------
  // Books + verses
  // ---------------------------------------------------------------------------

  (List<LocalizedBook>, List<Verse>) _parseBooksAndVerses(
    XmlDocument doc,
    List<PayloadIssue> issues,
    String translationId,
  ) {
    final books = <LocalizedBook>[];
    final verses = <Verse>[];

    final bookDivs = doc.xpath(
      "//*[local-name()='osisText']//*[local-name()='div'][@type='book']",
    );

    if (bookDivs.isEmpty) {
      throw const FormatException('OSIS: no <div type="book"> found.');
    }

    for (final node in bookDivs) {
      if (node is! XmlElement) continue;

      final osisBookId = node.getAttribute('osisID')?.trim();
      if (osisBookId == null || osisBookId.isEmpty) {
        issues.add(const PayloadIssue(
          severity: IssueSeverity.warning,
          code: 'book_missing_osisid',
          message: 'Book div missing osisID attribute.',
          pointer: 'Books',
        ));
        continue;
      }

      final bibleBook = BibleBook.fromProgrammaticId(osisBookId);
      if (bibleBook == null) {
        issues.add(PayloadIssue(
          severity: IssueSeverity.warning,
          code: 'book_unknown_code',
          message: 'Unknown OSIS book ID "$osisBookId" - skipping.',
          pointer: 'LocalizedBook($osisBookId)',
        ));
        continue;
      }

      // Title: namespace-safe scan of direct children
      final titleNodes = node.children
          .whereType<XmlElement>()
          .where((e) => e.name.local == 'title');
      final mainTitle =
          titleNodes.isEmpty ? '' : titleNodes.first.innerText.trim();
      final shortAttr =
          titleNodes.isEmpty ? null : titleNodes.first.getAttribute('short');

      final longName = mainTitle.isNotEmpty ? mainTitle : osisBookId;
      final shortName = (shortAttr ?? mainTitle).trim();

      books.add(LocalizedBook(
        book: bibleBook,
        longName: longName,
        shortName: shortName.isEmpty ? longName : shortName,
        abbreviation: null, // OSIS does not carry abbreviations
      ));

      verses.addAll(
        _parseVersesInBookDiv(node, bibleBook, translationId, issues),
      );
    }

    return (books, verses);
  }

  // ---------------------------------------------------------------------------
  // Verse content for a single book div
  // ---------------------------------------------------------------------------

  List<Verse> _parseVersesInBookDiv(
    XmlElement bookDiv,
    BibleBook bibleBook,
    String translationId,
    List<PayloadIssue> issues,
  ) {
    final verses = <Verse>[];
    final currentSpans = <VerseSpan>[];
    final buffer = StringBuffer();
    final styleStack = <_ActiveStyle>[];

    int? chapter;
    int? verseNumber;
    bool inVerse = false;
    int segmentIndex = 0;
    bool lastWasSpace = false;

    void appendNormalized(String s) {
      for (final rune in s.runes) {
        final ch = String.fromCharCode(rune);
        if (ch.trim().isEmpty) {
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

    void flushBuffer() {
      final text = buffer.toString();
      buffer.clear();
      if (text.isNotEmpty) {
        // Capture the state stack as a Set
        final activeStyles = styleStack.map((s) => s.type).toSet();
        // Keep the deepest non-null payload
        final activePayload = styleStack.reversed
            .map((s) => s.payload)
            .firstWhere((p) => p != null, orElse: () => null);

        currentSpans.add(VerseSpan(
          text: text,
          activeStyles: activeStyles,
          payload: activePayload,
        ));
      }
    }

    void flushVerse() {
      flushBuffer();
      if (chapter == null || verseNumber == null || currentSpans.isEmpty)
        return;

      verses.add(Verse(
        translationId: translationId,
        ref: BibleRef(
            book: bibleBook, chapter: chapter!, verseStart: verseNumber!),
        segments: [
          VerseSegment(
            segmentIndex: segmentIndex++,
            spans: List.unmodifiable(currentSpans),
          ),
        ],
      ));
      currentSpans.clear();
      lastWasSpace = false;
    }

    late void Function(XmlNode) walk;
    walk = (XmlNode node) {
      if (node is XmlElement) {
        final tag = node.name.local;
        if (_isSkipped(tag)) return;

        // ---- chapter boundary ----
        if (tag == 'chapter') {
          final n = node.getAttribute('n');
          if (n != null) chapter = int.tryParse(n);

          final parsed = _chapterFromOsisId(node.getAttribute('osisID'));
          if (parsed != null) chapter = parsed;

          for (final child in node.children) walk(child);
          return;
        }

        // ---- verse boundary ----
        if (tag == 'verse') {
          final osisId = node.getAttribute('osisID');
          final hasEnd = node.getAttribute('eID') != null;
          final hasStart = node.getAttribute('sID') != null;
          final isMilestone = node.children.isEmpty;

          // End milestone
          if (hasEnd) {
            if (inVerse) flushVerse();
            inVerse = false;
            verseNumber = null;
            return;
          }

          // Start milestone (KJV-style)
          if (hasStart || (isMilestone && osisId != null)) {
            if (inVerse) flushVerse();
            final n = node.getAttribute('n');
            verseNumber =
                n != null ? int.tryParse(n) : _verseFromOsisId(osisId);
            final parsedChapter = _chapterFromOsisId(osisId);
            if (parsedChapter != null) chapter = parsedChapter;
            inVerse = verseNumber != null;
            segmentIndex = 0;
            return;
          }

          // Container verse (Tagalog-style)
          if (osisId != null) {
            if (inVerse) flushVerse();
            final parsedChapter = _chapterFromOsisId(osisId);
            if (parsedChapter != null) chapter = parsedChapter;
            verseNumber = _verseFromOsisId(osisId);
            inVerse = verseNumber != null;
            segmentIndex = 0;

            for (final child in node.children) walk(child);

            if (inVerse) flushVerse();
            inVerse = false;
            verseNumber = null;
            return;
          }

          for (final child in node.children) walk(child);
          return;
        }

        // Handle Spans with Style Stack
        final st = _spanTypeFor(node);
        if (st != null) {
          flushBuffer();
          styleStack.add(_ActiveStyle(st, _spanPayload(node)));
          for (final child in node.children) walk(child);
          flushBuffer();
          styleStack.removeLast();
          return;
        }

        for (final child in node.children) walk(child);
        return;
      }
      if (node is XmlText && inVerse) appendNormalized(node.value);
    };

    for (final child in bookDiv.children) walk(child);
    if (inVerse) flushVerse();
    return verses;
  }

  // ---------------------------------------------------------------------------
  // Span helpers
  // ---------------------------------------------------------------------------

  bool _isSkipped(String tag) =>
      tag == 'note' || tag == 'rdg' || tag == 'rdgGrp';

  SpanType? _spanTypeFor(XmlElement el) {
    return switch (el.name.local) {
      'transChange' => (el.getAttribute('type') ?? '').toLowerCase() == 'added'
          ? SpanType.added
          : null,
      'hi' => switch ((el.getAttribute('type') ?? '').toLowerCase()) {
          final t when t.contains('bold') => SpanType.bold,
          final t when t.contains('italic') => SpanType.italic,
          _ => null,
        },
      'w' => SpanType.strongs,
      _ => null,
    };
  }

  String? _spanPayload(XmlElement el) {
    if (el.name.local == 'w') {
      return el.getAttribute('lemma') ?? el.getAttribute('morph');
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // OSIS ID helpers
  // ---------------------------------------------------------------------------

  int? _chapterFromOsisId(String? osisId) {
    if (osisId == null) return null;
    final parts = osisId.split('.');
    return parts.length >= 2 ? int.tryParse(parts[1]) : null;
  }

  int? _verseFromOsisId(String? osisId) {
    if (osisId == null) return null;
    final parts = osisId.split('.');
    return parts.length >= 3 ? int.tryParse(parts[2]) : null;
  }
}
