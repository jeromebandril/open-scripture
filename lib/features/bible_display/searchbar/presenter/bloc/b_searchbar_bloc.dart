import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/bible_reference.dart';

import '../../../../../../core/utils/bible_reference_parser.dart';

part 'b_searchbar_event.dart';
part 'b_searchbar_state.dart';

class BSearchbarBloc extends Bloc<BSearchbarEvent, BSearchbarState> {
  final BibleReferenceParser brParser;

  BSearchbarBloc({
    required this.brParser,
  }) : super(const BSearchbarState()) {
    on<BSearchbarAnalyze>(_onAnalyze);
  }

  Future<void> _onAnalyze(
    BSearchbarAnalyze event,
    Emitter<BSearchbarState> emit,
  ) async {
    final eitherFailureOrReference = brParser.analyze(event.prompt);

    eitherFailureOrReference.fold(
      (_) => print("> BSearchbar: not a valid prompt"),
      (ref) => emit(state.copyWith(
        status: () => BSearchbarStatus.success,
        referenceResult: () => ref,
      )),
    );
  }
}
