import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryVisibilityCubit extends Cubit<bool> {
  HistoryVisibilityCubit() : super(false);

  void toggle() {
    emit(!state);
  }

  void set(bool val) {
    emit(val);
  }
}
