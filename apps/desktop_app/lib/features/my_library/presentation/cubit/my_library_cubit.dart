import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/core/infrastructure/event_bus/install_notifier.dart';
import 'package:open_scripture/features/my_library/domain/repositories/my_library_repository.dart';
import 'package:open_scripture/shared/entities/bible_meta.dart';

part 'my_library_state.dart';

class MyLibraryCubit extends Cubit<MyLibraryState> {
  MyLibraryCubit({
    required MyLibraryRepository repo,
    required InstallNotifier notifier,
  })  : _repo = repo,
        super(MyLibraryState()) {
    _sub = notifier.stream.listen((_) => getBibles());
  }

  final MyLibraryRepository _repo;
  late final StreamSubscription _sub;

  Future<void> getBibles() async {
    emit(state.copywith(status: MyLibraryStatus.loading));

    final result = await _repo.getBibles();
    result.fold((f) {
      emit(state.copywith(
        status: MyLibraryStatus.error,
        errorMessage: () => f.message,
      ));
    }, (b) {
      emit(state.copywith(status: MyLibraryStatus.ready, bibles: b));
    });
  }

  void select(int index) => emit(state.copywith(
      selectedBibleIndex: () =>
          state.selectedBibleIndex == index ? null : index));

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
