import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/bible_reference_parser.dart';

part 'scripture_finder_event.dart';
part 'scripture_finder_state.dart';

class ScriptureFinderBloc
    extends Bloc<ScriptureFinderEvent, ScriptureFinderState> {
  final BibleReferenceParser brParser;

  ScriptureFinderBloc({
    required this.brParser,
  }) : super(ScriptureFinderInitial()) {
    on<ScriptureFinderEvent>((event, emit) {});
  }

  Stream<ScriptureFinderEvent> get event => event;
}
