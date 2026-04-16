part of 'remote_controller_cubit.dart';

class RemoteControllerState extends Equatable {
  const RemoteControllerState({
    this.isRunning = false,
    this.isBusy = false,
  });

  final bool isRunning;
  final bool isBusy;

  RemoteControllerState copyWith({
    bool? isRunning,
    bool? isBusy,
  }) {
    return RemoteControllerState(
      isRunning: isRunning ?? this.isRunning,
      isBusy: isBusy ?? this.isBusy,
    );
  }

  @override
  List<Object?> get props => [isRunning, isBusy];
}
