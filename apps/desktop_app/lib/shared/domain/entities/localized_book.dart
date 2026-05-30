import 'package:equatable/equatable.dart';
import 'bible_book.dart';

/// Represents a Bible book ready for display in a specific language.
/// It marries the pure domain concept (the Enum) with the localized UI strings.
class LocalizedBook extends Equatable {
  final BibleBook book; // The universal token (e.g., BibleBook.genesis)
  final String longName;
  final String shortName;
  final String? abbreviation;

  const LocalizedBook({
    required this.book,
    required this.longName,
    required this.shortName,
    this.abbreviation,
  });

  @override
  List<Object?> get props => [book, longName, shortName, abbreviation];
}
