part of 'presenter_cubit.dart';

enum PresenterStatus {
  error,
  ok,
}

class PresenterState extends Equatable {
  const PresenterState({
    this.status = PresenterStatus.ok,
    this.errorMessage,
    this.isShowing = false,
    this.slides = const [],
    this.currentSlideIndex = 0,
  });

  final PresenterStatus status;
  final String? errorMessage;
  final bool isShowing;
  final List<SlideData> slides;
  final int currentSlideIndex;

  int get numberOfSlides => slides.length;

  SlideData? getCurrentSlide() {
    if (slides.isEmpty) return null;
    return slides[currentSlideIndex];
  }

  PresenterState copyWith({
    PresenterStatus? status,
    String? Function()? errorMessage,
    bool? isShowing,
    List<SlideData>? slides,
    int? currentSlideIndex,
  }) {
    return PresenterState(
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      isShowing: isShowing ?? this.isShowing,
      slides: slides ?? this.slides,
      currentSlideIndex: currentSlideIndex ?? this.currentSlideIndex,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isShowing,
        slides,
        currentSlideIndex,
      ];
}
