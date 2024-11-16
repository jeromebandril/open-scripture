part of 'split_screen_bloc.dart';

enum SplitStatus {
  initial,
  error,
  success,
}

class SplitScreenState extends Equatable {
  const SplitScreenState({
    this.status = SplitStatus.initial,
    this.conf = const SplitConfiguration(),
    this.focusedId = 1,
    this.signalData,
  });

  final SplitStatus status;
  final SplitConfiguration conf;
  final int focusedId;
  final BibleRef? signalData;

  @override
  List<Object?> get props => [
        status,
        conf,
        focusedId,
        signalData,
      ];

  SplitScreenState copyWith({
    SplitStatus Function()? status,
    SplitConfiguration Function()? conf,
    int Function()? focusedId,
    BibleRef? Function()? signalData,
  }) {
    return SplitScreenState(
      status: status != null ? status() : this.status,
      conf: conf != null ? conf() : this.conf,
      focusedId: focusedId != null ? focusedId() : this.focusedId,
      signalData: signalData != null ? signalData() : this.signalData,
    );
  }
}
