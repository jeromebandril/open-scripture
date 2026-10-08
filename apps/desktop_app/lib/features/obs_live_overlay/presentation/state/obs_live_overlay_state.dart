part of 'obs_live_overlay_cubit.dart';

enum OverlayStatus { initial, error }

class ObsLiveOverlayState extends Equatable {
  const ObsLiveOverlayState({
    this.status = OverlayStatus.initial,
    required this.snapshot,
    required this.isRunning,
    this.pendingVerse,
    this.busy = false,
    this.error,
  });

  final OverlayStatus status;
  final OverlaySnapshot snapshot;
  final bool isRunning;
  final BibleRef? pendingVerse;
  final bool busy;
  final String? error;

  factory ObsLiveOverlayState.initial() => ObsLiveOverlayState(
        isRunning: false,
        busy: false,
        snapshot: OverlaySnapshot.initial(),
      );

  String get currentVerseStr =>
      snapshot.items['ref'] != null && snapshot.items['ref']!.visible
          ? snapshot.items['ref']!.text
          : '<empty>';

  ObsLiveOverlayState copyWith({
    OverlayStatus? status,
    OverlaySnapshot? snapshot,
    bool? isRunning,
    BibleRef? Function()? pendingVerse,
    bool? busy,
    String? error,
  }) {
    return ObsLiveOverlayState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      pendingVerse: pendingVerse != null ? pendingVerse() : this.pendingVerse,
      isRunning: isRunning ?? this.isRunning,
      busy: busy ?? this.busy,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [status, snapshot, isRunning, pendingVerse, busy, error];
}
