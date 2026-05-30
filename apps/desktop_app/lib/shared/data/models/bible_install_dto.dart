import 'package:open_scripture/core/infrastructure/database/database.dart';
import 'package:open_scripture/shared/domain/entities/bible_book.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/entities/verse.dart';

class TranslationInstallDto {
  final int? id;
  final String extId;
  final String name;
  final String? localName;
  final String abbreviation;
  final String? langIsoCode;
  final String? langEngName;
  final String? langNativeName;
  final String? originSource;
  final String? originFormat;
  final String? description;
  final String? copyright;

  const TranslationInstallDto({
    this.id,
    required this.extId,
    required this.name,
    this.localName,
    required this.abbreviation,
    this.langIsoCode,
    this.langEngName,
    this.langNativeName,
    this.originSource,
    this.originFormat,
    this.description,
    this.copyright,
  });
}

extension TranslationInstallDtoMapper on TranslationInstallDto {
  static TranslationInstallDto fromDatabase(Bible bible) {
    return TranslationInstallDto(
      id: bible.id,
      extId: bible.extId,
      name: bible.bName,
      localName: bible.nameLocal ?? bible.bName,
      abbreviation: bible.abbreviation,
      originSource: bible.originSource,
      originFormat: bible.originFormat,
      description: bible.bDescription,
      copyright: bible.copyright,
    );
  }

  BibleTranslation toDomain() {
    return BibleTranslation(
      localId: id,
      extId: extId,
      name: name,
      localName: localName,
      abbreviation: abbreviation,
      langIsoCode: langIsoCode,
      langEngName: langEngName,
      langNativeName: langNativeName,
      originSource: originSource,
      originFormat: originFormat,
      description: description,
      copyright: copyright,
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
