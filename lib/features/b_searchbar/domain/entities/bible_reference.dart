import 'package:equatable/equatable.dart';

class BibleReference extends Equatable {
  final String book;
  final int? chapter;
  final int? verseStart;
  final int? verseEnd;

  const BibleReference({
    required this.book,
    this.chapter,
    this.verseStart,
    this.verseEnd,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}
