import 'package:open_scripture/core/infrastructure/book_resolver/book_resolver.dart';
import 'package:open_scripture/shared/data/models/verse_span_model.dart';
import 'package:open_scripture/core/engines/bible_compiler/import/bible_importer.dart';
import 'package:open_scripture/core/engines/bible_compiler/domain/models/canonical_bible_package.dart';
import 'package:open_scripture/core/engines/bible_compiler/domain/models/payload_issue.dart';

import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

import 'package:open_scripture/shared/entities/bible_meta.dart';
import 'package:open_scripture/shared/entities/book.dart';
import 'package:open_scripture/shared/entities/verse_segment.dart';
import 'package:open_scripture/shared/entities/verse_span.dart';
import 'package:open_scripture/shared/entities/bible_ref.dart';
import 'package:open_scripture/shared/data/models/segment_key.dart';

import '../../../../di/injection_container.dart';
import '../../source/packages/source_package.dart';

// good luck future me, parsing bible is a pain

final class OsisImporter implements BibleImporter {
  static const int _canonicalSchemaVersion = 1;

  final _resolver = sl<BibleRefResolver>();

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

    // 1) Metadata
    final bibleMeta = _parseBibleMeta(doc, issues);

    // 2) Books + verse content
    final (books, segments, spans) = _parseBooksAndVerses(doc, issues);

    // 3) Header
    final packageId = await package.fingerprint();
    final header = CanonicalBibleHeader(
      packageId: packageId,
      sourceFormat: BibleSourceFormat.osis,
      schemaVersion: _canonicalSchemaVersion,
      origin: package.displayName,
      originDescription: 'Imported from ${package.displayName}',
    );

    final data = CanonicalBibleData(
      bibleMeta: bibleMeta,
      books: books,
      segments: segments,
      spans: [],
    );

    // _attachSpansToSegmentsIfSupported(segments, spans);

    return CanonicalBiblePackage(
      header: header,
      data: data,
      issues: issues,
    );
  }

  // -------------------------
  // Metadata parsing
  // -------------------------

  // Handle OSIS default namespace: xpath may require local-name().
  String _firstText(XmlDocument doc, String xpathExpr) {
    final nodes = doc.xpath(xpathExpr);
    if (nodes.isEmpty) return '';
    return nodes.first.innerText.trim();
  }

  BibleMeta _parseBibleMeta(XmlDocument doc, List<PayloadIssue> issues) {
    final title = _firstText(doc,
        "//*[local-name()='work'][@osisWork][1]/*[local-name()='title'][1]");
    final publisher = _firstText(doc,
        "//*[local-name()='work'][@osisWork][1]/*[local-name()='publisher'][1]");
    final identifier = _firstText(doc,
        "//*[local-name()='work'][@osisWork][1]/*[local-name()='identifier'][1]");
    final lang = _firstText(doc,
        "//*[local-name()='work'][@osisWork][1]/*[local-name()='language'][1]");
    final desc = _firstText(doc,
        "//*[local-name()='work'][@osisWork][1]/*[local-name()='description'][1]");
    final rights = _firstText(doc,
        "//*[local-name()='work'][@osisWork][1]/*[local-name()='rights'][1]");

    // Fallbacks
    final safeTitle = title.isEmpty ? 'Untitled' : title;

    if (title.isEmpty) {
      issues.add(const PayloadIssue(
        severity: IssueSeverity.warning,
        code: 'missing_title',
        message: 'Missing OSIS title in header/work.',
        pointer: 'BibleMeta.bibleName',
      ));
    }

    return BibleMeta(
      id: null,
      extId: identifier,
      bibleNameLocal: safeTitle,
      bibleName: safeTitle,
      abbreviation: identifier.isEmpty ? safeTitle : identifier,
      originSource: null,
      originFormat: formatId,
      description: desc,
      copyright: rights,
      langEngName: lang,
      langNativeName: lang,
      langIsoCode: lang,
    );
  }

  // -------------------------
  // Books + verses parsing
  // -------------------------

  (List<Book> books, List<VerseSegment> segments, List<VerseSpanModel> spans)
      _parseBooksAndVerses(XmlDocument doc, List<PayloadIssue> issues) {
    final books = <Book>[];
    final segments = <VerseSegment>[];
    final spans = <VerseSpanModel>[];

    // OSIS structure:
    // <osisText> <div type="bookGroup"> <div type="book" osisID="Gen"> ...
    final bookDivs = doc.xpath(
      "//*[local-name()='osisText']"
      "//*[local-name()='div'][@type='book']",
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

      // Book title: <title type="main" short="Genesis">The First Book ...</title>
      final titleEl = node
          .findElements(
              'title') // may fail due to namespace; so do local-name scan
          .firstWhere(
            (e) => e.name.local == 'title',
            orElse: () => XmlElement(XmlName('title')),
          );

      // Namespace-safe: search direct children by local-name
      final titleNodes = node.children.whereType<XmlElement>().where(
            (e) => e.name.local == 'title',
          );
      final mainTitle =
          titleNodes.isEmpty ? '' : titleNodes.first.innerText.trim();
      final shortAttr =
          titleNodes.isEmpty ? null : titleNodes.first.getAttribute('short');

      final shortName = (shortAttr ?? mainTitle).trim();
      final longName = mainTitle.isNotEmpty ? mainTitle : shortName;

      books.add(Book(
        osisId: _normalizeBookId(osisBookId),
        longName: longName.isEmpty ? shortName : longName,
        shortName: shortName.isEmpty ? osisBookId : shortName,
        abbr: null,
      ));

      // Parse verses inside this book div.
      final (bookSegments, bookSpans) =
          _parseVersesInBookDiv(node, osisBookId, issues);
      segments.addAll(bookSegments);
      spans.addAll(bookSpans);
    }

    return (books, segments, spans);
  }

  String _normalizeBookId(String osisId) {
    return osisId.toUpperCase();
  }

  int? _parseChapterFromOsisId(String? osisId) {
    if (osisId == null) return null;
    // "Gen.1" or "Gen.1.1"
    final parts = osisId.split('.');
    if (parts.length < 2) return null;
    return int.tryParse(parts[1]);
  }

  (List<VerseSegment>, List<VerseSpanModel>) _parseVersesInBookDiv(
    XmlElement bookDiv,
    String bookOsisId,
    List<PayloadIssue> issues,
  ) {
    final segments = <VerseSegment>[];
    final spans = <VerseSpanModel>[];
    final bookUsfxId = _resolver.resolveBook(bookOsisId)!.usfxId;

    int? chapter;
    int? verse;
    bool inVerse = false;
    int segmentIndex = 0;

    final buffer = StringBuffer();
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

    bool isSpanElement(XmlElement el) {
      final name = el.name.local;

      // Common OSIS span-ish tags:
      // - <transChange type="added">...</transChange>
      // - <hi type="bold|italic|...">...</hi>
      // - <w lemma="strong:H0430">...</w>
      return name == 'transChange' || name == 'hi' || name == 'w';
    }

    SpanType? spanTypeFor(XmlElement el) {
      switch (el.name.local) {
        case 'transChange':
          if ((el.getAttribute('type') ?? '').toLowerCase() == 'added') {
            return SpanType.add;
          }
          return null;

        case 'hi':
          final t = (el.getAttribute('type') ?? '').toLowerCase();
          if (t.contains('bold')) return SpanType.bold;
          if (t.contains('italic')) return SpanType.italic;
          return null;

        case 'w':
          // Usually denotes a word with lemma/morphology.
          return SpanType.strongWords;

        default:
          return null;
      }
    }

    String? spanPayload(XmlElement el) {
      if (el.name.local == 'w') {
        // OSIS may encode lemma like "strong:H0430" or "Strong:H0430"
        return el.getAttribute('lemma') ?? el.getAttribute('morph');
      }
      return null;
    }

    // OSIS verse boundaries:
    // <chapter ... n="1" />
    // <verse osisID="Gen.1.1" n="1" /> ... <verse eID="Gen.1.1.seID..." />
    //
    // We'll treat:
    // - <chapter n="..."> as setting chapter
    // - <verse ... n="..."> (or osisID parse) as start marker, flush previous
    // - <verse eID="..."> as end marker, flush current
    void walk(XmlNode node) {
      if (node is XmlElement) {
        final tag = node.name.local;

        if (tag == 'chapter') {
          // milestone chapter: <chapter n="1"/>
          final nn = node.getAttribute('n');
          if (nn != null) {
            chapter = int.tryParse(nn);
          }

          // container chapter: <chapter osisID="Gen.1">...</chapter>
          final parsedChapter =
              _parseChapterFromOsisId(node.getAttribute('osisID'));
          if (parsedChapter != null) chapter = parsedChapter;

          // IMPORTANT: traverse children (container chapters)
          for (final child in node.children) {
            walk(child);
          }
          return;
        }

        if (tag == 'verse') {
          final osisId = node.getAttribute('osisID');
          final hasEndMilestone = node.getAttribute('eID') != null;
          final hasStartMilestone = node.getAttribute('sID') != null;
          final isSelfClosing =
              node.children.isEmpty; // milestone <verse ... />

          if (hasEndMilestone) {
            if (inVerse) flushVerse();
            inVerse = false;
            verse = null;
            return;
          }

          // Milestone start (KJV style)
          if (hasStartMilestone || (isSelfClosing && osisId != null)) {
            if (inVerse) flushVerse();

            verse = node.getAttribute('n') != null
                ? int.tryParse(node.getAttribute('n')!)
                : _parseVerseFromOsisId(osisId);

            final parsedChapter = _parseChapterFromOsisId(osisId);
            if (parsedChapter != null) chapter = parsedChapter;

            inVerse = verse != null;
            segmentIndex = 0;
            return;
          }

          // Container verse (Tagalog style): <verse osisID="Gen.1.1"> ... </verse>
          if (osisId != null) {
            if (inVerse) flushVerse(); // safety

            final parsedChapter = _parseChapterFromOsisId(osisId);
            if (parsedChapter != null) chapter = parsedChapter;

            verse = _parseVerseFromOsisId(osisId);
            inVerse = verse != null;

            // IMPORTANT: reset segment index for this verse
            segmentIndex = 0;

            // Traverse children to collect text/spans
            for (final child in node.children) {
              walk(child);
            }

            // Verse ends at closing tag
            if (inVerse) flushVerse();
            inVerse = false;
            verse = null;
            return;
          }

          // Otherwise: traverse
        }

        // Skip header
        if (!inVerse && tag == 'header') return;

        // Span capture
        if (inVerse && isSpanElement(node)) {
          final start = buffer.length;
          for (final child in node.children) {
            walk(child);
          }
          final end = buffer.length;

          final st = spanTypeFor(node);
          if (st != null && end > start && chapter != null && verse != null) {
            spans.add(VerseSpanModel(
              key: SegmentKey(
                bookUsfxId: bookUsfxId,
                chapter: chapter!,
                verse: verse!,
                segmentIndex: segmentIndex,
              ),
              startOffset: start,
              endOffset: end,
              type: st,
              payload: spanPayload(node),
            ));
          }
          return;
        }

        // Default traversal
        for (final child in node.children) {
          walk(child);
        }
        return;
      }

      if (node is XmlText) {
        if (inVerse) appendNormalized(node.value);
      }
    }

    for (final child in bookDiv.children) {
      walk(child);
    }
    if (inVerse) flushVerse();

    return (segments, spans);
  }

  int? _parseVerseFromOsisId(String? osisId) {
    if (osisId == null) return null;
    // Example: "Gen.1.2"
    final parts = osisId.split('.');
    if (parts.length < 3) return null;
    return int.tryParse(parts[2]);
  }

  void _attachSpansToSegmentsIfSupported(
    List<VerseSegment> segments,
    List<VerseSpanModel> spans,
  ) {
    throw UnimplementedError();
  }
}
