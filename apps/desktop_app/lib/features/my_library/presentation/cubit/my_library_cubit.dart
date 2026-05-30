import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/core/infrastructure/event_bus/install_notifier.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/repositories/bible_catalog_repository.dart';
import 'package:open_scripture/shared/domain/repositories/bible_install_repository.dart';

part 'my_library_state.dart';

class MyLibraryCubit extends Cubit<MyLibraryState> {
  final BibleCatalogRepository _catalogRepo;
  final BibleInstallRepository _installRepo;
  late final StreamSubscription _sub;

  MyLibraryCubit({
    required BibleCatalogRepository repo,
    required InstallNotifier notifier,
    required BibleInstallRepository installRepo,
  })  : _installRepo = installRepo,
        _catalogRepo = repo,
        super(MyLibraryState()) {
    _sub = notifier.stream.listen((_) => getBibles());
  }

  Future<void> getBibles() async {
    emit(state.copywith(status: MyLibraryStatus.loading));

    final result = await _catalogRepo.getAvailableBibles();

    result.fold((f) {
      emit(state.copywith(
        status: MyLibraryStatus.error,
        errorMessage: () => f.message,
      ));
    }, (b) {
      emit(state.copywith(
        status: MyLibraryStatus.ready,
        bibles: b,
      ));
    });
  }

  Future<void> uninstall(int bibleId) async {
    await _installRepo.uninstall(bibleId);
    getBibles();
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
