import 'package:flutter_bloc/flutter_bloc.dart';

class ToolbarCubit extends Cubit<bool> {
  ToolbarCubit() : super(true);

  void toggleVisibility() {
    emit(!state);
  }
}
