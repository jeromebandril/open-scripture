import 'package:equatable/equatable.dart';

import '../../../../text_scaler/presentation/state/text_scaler_cubit.dart';
import '../../../bible_pane/presentation/state/bible_pane_bloc.dart';

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
