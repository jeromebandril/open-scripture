import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'text_scaler_state.dart';

const sensitivity = 0.05;
const lowerLimit = 1.0;
const highestLimit = 10.0;

class TextScalerCubit extends Cubit<TextScalerState> {
  TextScalerCubit() : super(TextScalerState());

  void _setTextScaleFactor(double textScaleFactor) {
    textScaleFactor = textScaleFactor.clamp(lowerLimit, highestLimit);
    emit(TextScalerState(textScaleFactor: textScaleFactor));
  }

  void initWith(double textScalerFactor) {
    _setTextScaleFactor(textScalerFactor);
  }

  void zoomIn({double multiplier = 1}) {
    _setTextScaleFactor(state.textScaleFactor + sensitivity * multiplier);
  }

  void zoomOut({double multiplier = 1}) {
    _setTextScaleFactor(state.textScaleFactor - sensitivity * multiplier);
  }
}
