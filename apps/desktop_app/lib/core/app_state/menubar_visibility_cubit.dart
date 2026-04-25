import 'package:flutter_bloc/flutter_bloc.dart';

class MenubarCubit extends Cubit<bool> {
  MenubarCubit() : super(true);

  void toggleVisibility() {
    emit(!state);
  }
}
