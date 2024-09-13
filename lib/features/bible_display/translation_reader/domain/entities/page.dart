import 'package:equatable/equatable.dart';

import '../../../../../core/domain/entities/translation.dart';

class PageContent extends Equatable {
  final bool isHeterogeneous;
  final String? booknameAbbreviation;
  final String? booknameFull;
  final int? chapterNumber;
  final List<Paragraph> content;

  const PageContent({
    required this.content,
    this.booknameAbbreviation,
    this.booknameFull,
    this.chapterNumber,
    this.isHeterogeneous = false,
  });

  @override
  List<Object?> get props => [
        content,
        isHeterogeneous,
        booknameAbbreviation,
        booknameFull,
        chapterNumber,
      ];
}
