part of 'presenter_cubit.dart';

class PresenterState extends Equatable {
  const PresenterState({
    this.isShowing = false,
    this.slides = const [],
    this.currentSlideIndex = 0,
  });

  final bool isShowing;
  final List<SlideData> slides;
  final int currentSlideIndex;

  int get numberOfSlides => slides.length;

  SlideData? getCurrentSlide() {
    if (slides.isEmpty) return null;
    return slides[currentSlideIndex];
  }

  PresenterState copyWith({
    bool? isShowing,
    List<SlideData>? slides,
    int? currentSlideIndex,
  }) {
    return PresenterState(
      isShowing: isShowing ?? this.isShowing,
      slides: slides ?? this.slides,
      currentSlideIndex: currentSlideIndex ?? this.currentSlideIndex,
    );
  }

  @override
  List<Object> get props => [isShowing, slides, currentSlideIndex];
}
