import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/slide_data.dart';

part 'presenter_state.dart';

class PresenterCubit extends Cubit<PresenterState> {
  PresenterCubit() : super(PresenterState());

  void toggleShow() {
    if (!state.isShowing && state.slides.isEmpty) return;
    emit(state.copyWith(isShowing: !state.isShowing));
  }

  void updateSlides(List<SlideData> slides) {
    emit(state.copyWith(slides: slides));
  }

  void goNextSlide() => _moveSlide(1);

  void goPrevSlide() => _moveSlide(-1);

  void _moveSlide(int delta) {
    int finalSlideIndex = state.currentSlideIndex + delta;
    if (finalSlideIndex < 0) finalSlideIndex = 0;
    if (finalSlideIndex >= state.numberOfSlides) {
      finalSlideIndex = state.numberOfSlides - 1;
    }
    emit(state.copyWith(currentSlideIndex: finalSlideIndex));
  }
}
