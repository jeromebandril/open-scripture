part of 'text_scaler_cubit.dart';

class TextScalerState extends Equatable {
  const TextScalerState({
    this.textScaleFactor = 1.0,
  });

  final double textScaleFactor;

  @override
  List<Object> get props => [textScaleFactor];
}
