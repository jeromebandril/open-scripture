import 'package:equatable/equatable.dart';
import 'package:open_scripture/shared/domain/entities/bible_meta.dart';
import 'package:open_scripture/shared/domain/entities/book.dart';
import 'package:open_scripture/shared/domain/entities/verse_segment.dart';

import '../../../../domain/entities/verse_span.dart';
import 'payload_issue.dart';

enum BibleSourceFormat { osis, usfx }

class CanonicalBiblePackage {
  final CanonicalBibleHeader header;
  final CanonicalBibleData data;
  final List<PayloadIssue> issues;

  const CanonicalBiblePackage({
    required this.header,
    required this.data,
    this.issues = const [],
  });

  bool get hasErrors => issues.any((i) => i.severity == IssueSeverity.error);
}

class CanonicalBibleHeader extends Equatable {
  final String packageId;
  final BibleSourceFormat sourceFormat;
  final int schemaVersion;
  final String origin;
  final String originDescription;

  const CanonicalBibleHeader({
    required this.packageId,
    required this.sourceFormat,
    required this.schemaVersion,
    required this.origin,
    required this.originDescription,
  });

  String get fingerprint => '$sourceFormat:$schemaVersion:$packageId';

  @override
  List<Object?> get props => [
        packageId,
        sourceFormat,
        schemaVersion,
        origin,
        originDescription,
      ];
}

final class CanonicalBibleData extends Equatable {
  final BibleMeta bibleMeta;
  final List<Book> books;
  final List<VerseSegment> segments;
  final List<VerseSpan> spans;

  const CanonicalBibleData({
    required this.books,
    required this.bibleMeta,
    required this.segments,
    required this.spans,
  });

  @override
  List<Object?> get props => [bibleMeta, books, segments, spans];
}
