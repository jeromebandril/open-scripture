import 'package:equatable/equatable.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/entities/localized_book.dart';
import 'package:open_scripture/shared/domain/entities/verse.dart';

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
  final BibleTranslation bibleTranslation;
  final List<LocalizedBook> books;
  final List<Verse> verses;

  const CanonicalBibleData({
    required this.bibleTranslation,
    required this.books,
    required this.verses,
  });

  @override
  List<Object?> get props => [bibleTranslation, books, verses];
}
