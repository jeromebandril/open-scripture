import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presentation/cubit/bible_selector_cubit.dart';
import 'package:open_scripture/features/text_scaler/presentation/state/text_scaler_cubit.dart';

import '../../../../../shared/entities/bible_ref.dart';
import '../../../bible_pane/presentation/state/bible_pane_bloc.dart';

class PaneDescriptor extends Equatable {
  const PaneDescriptor({
    required this.id,
    this.ref,
    this.bibleId,
    this.sizeFactor = 1,
  });

  final int id;
  final BibleRef? ref;
  final int? bibleId;
  final double sizeFactor;

  PaneDescriptor copyWith({
    BibleRef? ref,
    int? bibleId,
    double? sizeFactor,
  }) {
    return PaneDescriptor(
      id: id,
      ref: ref ?? this.ref,
      bibleId: bibleId ?? this.bibleId,
      sizeFactor: sizeFactor ?? this.sizeFactor,
    );
  }

  @override
  List<Object?> get props => [id, ref, bibleId, sizeFactor];
}

class PaneBlocComponents extends Equatable {
  final BiblePaneBloc bloc;
  final TextScalerCubit textScalerCubit;
  final BibleSelectorCubit bibleSelectorCubit;

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
