import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import '../../domain/entities/slide_data.dart';
import '../../domain/repositories/presenter_repository.dart';

part 'presenter_state.dart';

const _testData = [
  {
    "id": "1",
    "title": "The Six Enemies in the Believer’s Spiritual Battle",
    "subtitle":
        "Recognizing the battles that threaten our faith and walk with God"
  },
  {
    "id": "2",
    "title": "Satan — The Adversary",
    "subtitle": "The enemy who opposes God’s people"
  },
  {
    "id": "3",
    "title": "The Flesh — The Enemy Within",
    "subtitle": "The sinful nature that pulls us away from God"
  },
  {
    "id": "4",
    "title": "The World — The Enemy Around Us",
    "subtitle": "The system of values that draws our hearts away from God"
  },
  {
    "id": "5",
    "title": "Temptation — The Battle at the Door",
    "subtitle": "The opportunity to choose sin instead of obedience"
  },
  {
    "id": "6",
    "title": "Fear — The Enemy of Faith",
    "subtitle": "Fear weakens our trust in God and His promises"
  },
  {
    "id": "7",
    "title": "False Doctrine — The Enemy of Truth",
    "subtitle": "Error leads us away from God’s Word"
  },
];

class PresenterCubit extends Cubit<PresenterState> {
  static const kLimitNumOfSlides = 20;

  final PresenterRepository _repo;

  PresenterCubit({required PresenterRepository repo})
      : _repo = repo,
        super(PresenterState()) {
    _restorePreviousSession();
  }

  void _restorePreviousSession() async {
    final result = await _repo.restorePreviousSession().run();

    result.fold(
      (failure) {},
      (slides) => updateSlides(slides),
    );
  }

  // TODO: remember to delete this when it is not used anymore
  void loadDemoData() {
    final slides = [
      for (final data in _testData)
        SlideData(
          id: data['id']!,
          title: data["title"]!,
          subtitle: data["subtitle"]!,
        ),
    ];
    updateSlides(slides);
  }

  void toggleShow() {
    _toggleStatus(PresenterStatus.showing);
  }

  void toggleExpand() {
    _toggleStatus(PresenterStatus.expanded);
  }

  void updateSlides(List<SlideData> slides) async {
    final limitedSlides = slides.take(kLimitNumOfSlides).toList();

    emit(state.copyWith(
      slides: limitedSlides,
      currentSlideIndex: state.currentSlideIndex >= limitedSlides.length
          ? (limitedSlides.length - 1).clamp(0, kLimitNumOfSlides)
          : null,
    ));

    await _repo.saveSession(slides: limitedSlides).run();
  }

  void goNextSlide() => _moveSlide(1);

  void goPrevSlide() => _moveSlide(-1);

  void import() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
      withReadStream: false,
      allowMultiple: false,
      lockParentWindow: true,
    );

    // Aborted
    if (result == null) {
      return;
    }

    final picked = result.files.single;
    picked.bytes;
  }

  void _moveSlide(int delta) {
    int finalSlideIndex = state.currentSlideIndex + delta;
    if (finalSlideIndex < 0) finalSlideIndex = 0;
    if (finalSlideIndex >= state.numberOfSlides) {
      finalSlideIndex = state.numberOfSlides - 1;
    }
    emit(state.copyWith(currentSlideIndex: finalSlideIndex));
  }

  void _toggleStatus(PresenterStatus targetStatus) {
    if (!_canShowPresenter()) return;
    final status =
        state.status == targetStatus ? PresenterStatus.hidden : targetStatus;
    emit(state.copyWith(status: status));
  }

  bool _canShowPresenter() {
    if (state.slides.isNotEmpty) return true;

    emit(state.copyWith(
      status: PresenterStatus.error,
      errorMessage: () => 'You need to setup a presentation first',
    ));
    return false;
  }
}
