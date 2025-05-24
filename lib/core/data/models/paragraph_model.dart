import 'package:equatable/equatable.dart';

class ParagraphModel extends Equatable {
  final int? id;
  final int bookId;
  final int chapterNumber;
  final String? subtitle;

  const ParagraphModel({
    this.id,
    required this.bookId,
    required this.chapterNumber,
    this.subtitle,
  });

  @override
  List<Object?> get props => [id, bookId, chapterNumber, subtitle];
}
