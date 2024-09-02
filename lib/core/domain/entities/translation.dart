import 'package:equatable/equatable.dart';

import '../../../features/bible_display/searchbar/domain/entity/bible_reference.dart';

class Translation extends Equatable {
  final String name;
  final String abbreviation;
  final String language;
  final Map<String, Book> bookNames;

  const Translation({
    required this.name,
    required this.abbreviation,
    required this.language,
    required this.bookNames,
  });

  @override
  List<Object?> get props => [name, abbreviation, language, bookNames];
}

class Book extends Equatable {
  final String abbr;
  final String short;
  final String long;
  //
  final List<Chapter> chapters;

  const Book({
    required this.abbr,
    required this.short,
    required this.long,
    required this.chapters,
  });

  @override
  List<Object?> get props => [abbr, short, long, chapters];
}

class Chapter extends Equatable {
  final int number;
  final List<Paragraph> paragraphs;

  const Chapter({
    required this.number,
    required this.paragraphs,
  });

  @override
  List<Object?> get props => [number, paragraphs];
}

class Paragraph extends Equatable {
  final String title;
  final List<Verse> verses;

  const Paragraph({
    required this.title,
    required this.verses,
  });

  @override
  List<Object?> get props => [title, verses];
}

class Verse extends Equatable {
  final int number;
  final List<Snippet> words;

  const Verse({
    required this.number,
    required this.words,
  });

  @override
  List<Object?> get props => [number, words];
}

class Snippet extends Equatable {
  final String text;
  final String? scn; // = strong concordance number
  final bool wordOfJesus;
  final bool bold;
  final bool underlined;
  final bool italics;

  const Snippet({
    required this.text,
    this.scn,
    this.wordOfJesus = false,
    this.bold = false,
    this.underlined = false,
    this.italics = false,
  });

  @override
  List<Object?> get props => [
        text,
        scn,
        wordOfJesus,
        bold,
        underlined,
        italics,
      ];
}

/*
* different data structure: map
*/

class Bible {
  final Map<BibleReference, Verse> amp;

  const Bible(this.amp);
}
