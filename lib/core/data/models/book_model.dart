import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  final int? id;
  final String longName;
  final String shortName;
  final int bibleId;
  final int? bookOrder;

  const BookModel({
    this.id,
    required this.longName,
    required this.shortName,
    required this.bibleId,
    this.bookOrder,
  });

  @override
  List<Object?> get props => [id, longName, shortName, bibleId, bookOrder];
}
