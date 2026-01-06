import 'package:flutter_bloc/flutter_bloc.dart';

class ActivePaneCubit extends Cubit<int> {
  ActivePaneCubit({int initialPaneId = 0}) : super(initialPaneId);

  void setActive(int paneId) => emit(paneId);
}
