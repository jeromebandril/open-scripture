import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final int? id;
  final String? usfxId;
  final String? osisId;
  final String longName;
  final String shortName;
  final String? abbr;
  final int? bibleId;
  final int? bookOrder;

  const Book({
    this.id,
    this.usfxId,
    required this.longName,
    required this.shortName,
    this.abbr,
    this.bookOrder,
    this.bibleId,
    this.osisId,
  });

  @override
  List<Object?> get props => [
        id,
        usfxId,
        osisId,
        longName,
        shortName,
        abbr,
        bibleId,
        bookOrder,
      ];
}
