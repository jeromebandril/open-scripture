import 'package:the_smyrna_bible_v2/features/bible_display/searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/domain/repositories/split_screen_repository.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_screen/presenter/bloc/split_screen_bloc.dart';

class SplitScreenRepositoryImpl implements SplitScreenRepository {
  final BSearchbarBloc _searchbarBloc;
  final SplitScreenBloc _splitScreenBloc;

  SplitScreenRepositoryImpl(
    this._searchbarBloc,
    this._splitScreenBloc,
  ) {
    print("star listenning");
    _searchbarBloc.stream.listen((state) {
      print("nope");
      if (state.status == BSearchbarStatus.success &&
          state.referenceResult != null) {
        print("yes");
        _splitScreenBloc.add(
          SplitScreenSendSignal(data: state.referenceResult),
        );
      }
    }, onError: (error) {
      print("error");
    });
  }
}
