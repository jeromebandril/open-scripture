part of 'presenter_cubit.dart';

enum PresenterStatus {
  error,
  hidden,
  showing,
  expanded,
}

class PresenterState extends Equatable {
  const PresenterState({
    this.status = PresenterStatus.hidden,
    this.errorMessage,
    this.slides = const [],
    this.currentSlideIndex = 0,
  });

  final PresenterStatus status;
  final String? errorMessage;
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
    List<SlideData>? slides,
    int? currentSlideIndex,
  }) {
    return PresenterState(
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      slides: slides ?? this.slides,
      currentSlideIndex: currentSlideIndex ?? this.currentSlideIndex,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        slides,
        currentSlideIndex,
      ];
}
