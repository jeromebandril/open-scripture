import 'package:equatable/equatable.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../text_scaler/presentation/state/text_scaler_cubit.dart';
import '../../../bible_pane/presentation/state/bible_pane_bloc.dart';

class PaneDescriptor extends Equatable {
  const PaneDescriptor({
    required this.id,
    this.sizeFactor = 1,
  });

  final int id;
  final double sizeFactor;

  PaneDescriptor copyWith({
    BibleRef? ref,
    double? sizeFactor,
  }) {
    return PaneDescriptor(
      id: id,
      sizeFactor: sizeFactor ?? this.sizeFactor,
    );
  }

  @override
  List<Object?> get props => [id, sizeFactor];
}

class PaneBlocComponents extends Equatable {
  final BiblePaneBloc bloc;
  final TextScalerCubit textScalerCubit;

  const PaneBlocComponents({
    required this.bloc,
    required this.textScalerCubit,
  });

  Future<void> close() async {
    bloc.close();
    textScalerCubit.close();
  }

  @override
  List<Object?> get props => [bloc, textScalerCubit];
}
