import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_span.dart';

class SelectedWordCubit extends Cubit<WordInfo?> {
  SelectedWordCubit() : super(null);

  void setSelectedWord(WordInfo selectedWord) => emit(selectedWord);
}

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
