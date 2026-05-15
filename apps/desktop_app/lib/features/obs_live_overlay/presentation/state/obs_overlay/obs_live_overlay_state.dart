part of 'obs_live_overlay_cubit.dart';

enum OverlayStatus { initial, error }

class ObsLiveOverlayState extends Equatable {
  const ObsLiveOverlayState({
    this.status = OverlayStatus.initial,
    required this.snapshot,
    required this.isRunning,
    this.busy = false,
    this.error,
  });

  final OverlayStatus status;
  final OverlaySnapshot snapshot;
  final bool isRunning;
  final bool busy;
  final String? error;

  factory ObsLiveOverlayState.initial() => ObsLiveOverlayState(
        isRunning: false,
        busy: false,
        snapshot: OverlaySnapshot.initial(),
      );

  ObsLiveOverlayState copyWith({
    OverlayStatus? status,
    OverlaySnapshot? snapshot,
    bool? isRunning,
    bool? busy,
    String? error,
  }) {
    return ObsLiveOverlayState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      isRunning: isRunning ?? this.isRunning,
      busy: busy ?? this.busy,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, snapshot, isRunning, busy, error];
}
