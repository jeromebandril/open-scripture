import 'package:open_scripture/core/infrastructure/database/database.dart';
import 'package:open_scripture/shared/domain/entities/bible_book.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/entities/verse.dart';

class TranslationInstallDto {
  final String extId;
  final String name;
  final String abbreviation;
  final String? description;

  const TranslationInstallDto({
    required this.extId,
    required this.name,
    required this.abbreviation,
    this.description,
  });
}

extension TranslationInstallDtoMapper on TranslationInstallDto {
  static TranslationInstallDto fromDatabase(Bible bible) {
    return TranslationInstallDto(
      extId: bible.extId,
      name: bible.bName,
      abbreviation: bible.abbreviation,
    );
  }

  BibleTranslation toDomain() {
    return BibleTranslation(
      extId: extId,
      name: name,
      abbreviation: abbreviation,
      description: description,
      localName: name,
    );
  }
}

class BookInstallDto {
  final BibleBook book;
  final String longName;
  final String shortName;

  const BookInstallDto({
    required this.book,
    required this.longName,
    required this.shortName,
  });
}

class VerseSegmentInstallDto {
  // The universal ID linking this to the 'canonical_books' table
  final BibleBook book;
  final int chapter;
  final int verse;
  final int segmentIndex;
  final bool isParagraphStart;

  // It is the responsibility of the concrete Drift DataSource
  // to turn this list into a JSON string for SQLite.
  final List<VerseSpan> spans;

  const VerseSegmentInstallDto({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.segmentIndex,
    required this.isParagraphStart,
    required this.spans,
  });
}
