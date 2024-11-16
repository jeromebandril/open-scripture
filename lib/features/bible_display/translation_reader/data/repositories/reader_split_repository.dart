import '../../../split_screen/presenter/bloc/split_screen_bloc.dart';
import '../../presentation/bloc/reader_bloc.dart';

class ReaderSplitRepository {
  final SplitScreenBloc _splitScreenBloc;
  final ReaderBloc _readerBloc;

  ReaderSplitRepository(
    this._splitScreenBloc,
    this._readerBloc,
  ) {
    print("listenning to SplitScreenBloc");
    _splitScreenBloc.stream.listen((state) {
      if (true) {
        _readerBloc.add(ReaderReadChapter(state.signalData!));
      }
    });
  }
}
