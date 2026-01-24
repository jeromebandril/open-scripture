import 'package:flutter_bloc/flutter_bloc.dart';

enum DisplayMode {
  normal,
  presentation,
}

class DisplayModeCubit extends Cubit<DisplayMode> {
  DisplayModeCubit() : super(DisplayMode.normal);

  void set(DisplayMode dm) {
    emit(dm);
  }
}
