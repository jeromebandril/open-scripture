import '../../domain/entities/bible_book.dart';
import '../../domain/entities/localized_book.dart';

class BookDto {
  final String bookToken;
  final String longName;
  final String shortName;
  final String? abbr;

  BookDto({
    required this.bookToken,
    required this.longName,
    required this.shortName,
    this.abbr,
  });
}

extension BookDtoMapper on BookDto {
  LocalizedBook toDomain() {
    return LocalizedBook(
      book: BibleBook.fromProgrammaticId(bookToken)!,
      longName: longName,
      shortName: shortName,
    );
  }
}
