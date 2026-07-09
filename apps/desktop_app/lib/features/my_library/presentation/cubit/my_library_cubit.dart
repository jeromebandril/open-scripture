import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/infrastructure/event_bus/install_notifier.dart';
import '../../../../shared/domain/entities/bible_translation.dart';
import '../../../../shared/domain/repositories/bible_catalog_repository.dart';
import '../../../../shared/domain/repositories/bible_install_repository.dart';
import '../../../../shared/enums/bible_repository_type.dart';

part 'my_library_state.dart';

class MyLibraryCubit extends Cubit<MyLibraryState> {
  final BibleCatalogRepository _catalogRepo;
  final BibleInstallRepository? _installRepo;
  late final StreamSubscription _sub;

  MyLibraryCubit({
    required BibleCatalogRepository repo,
    required InstallNotifier notifier,
    BibleInstallRepository? installRepo,
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

  Future<void> uninstall(BibleTranslation bible) async {
    if (_installRepo == null) return;
    emit(state
        .copywith(uninstallingBibles: [...state.uninstallingBibles, bible]));
    await _installRepo.uninstall(
      bible.localId ?? bible.extId.externalId,
      bible.extId.repoType,
    );
    emit(state.copywith(
      selectedBibleIndex: () => null,
      uninstallingBibles: [...state.uninstallingBibles]..remove(bible),
    ));
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

  void filter(String query) =>
      emit(state.copywith(filterQuery: query, selectedBibleIndex: () => null));
}
