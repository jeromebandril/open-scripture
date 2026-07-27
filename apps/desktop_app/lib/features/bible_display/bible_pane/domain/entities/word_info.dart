import 'package:equatable/equatable.dart';

import '../../../../../shared/domain/entities/verse.dart';

class WordInfo extends Equatable {
  final String text;
  final VerseSpan span;

  const WordInfo({
    required this.text,
    required this.span,
  });

  @override
  List<Object?> get props => [text, span];
}
