import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presentation/state/bible_selector_bloc.dart';
import 'package:open_scripture/features/text_scaler/presentation/state/text_scaler_cubit.dart';

import '../../../../../shared/entities/bible_ref.dart';
import '../../../bible_pane/presentation/state/bible_pane_bloc.dart';

class PaneDescriptor extends Equatable {
  const PaneDescriptor({
    required this.id,
    this.ref,
    this.bibleId,
  });

  final int id;
  final BibleRef? ref;
  final int? bibleId;

  @override
  List<Object?> get props => [id, ref, bibleId];
}

class PaneBlocComponents extends Equatable {
  final BiblePaneBloc bloc;
  final TextScalerCubit textScalerCubit;
  final BibleSelectorBloc bibleSelectorCubit;

  const PaneBlocComponents({
    required this.bloc,
    required this.textScalerCubit,
    required this.bibleSelectorCubit,
  });

  Future<void> close() async {
    bloc.close();
    textScalerCubit.close();
    bibleSelectorCubit.close();
  }

  @override
  List<Object?> get props => [bloc, textScalerCubit, bibleSelectorCubit];
}
