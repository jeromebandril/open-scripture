part of 'remote_controller_cubit.dart';

class RemoteControllerState extends Equatable {
  const RemoteControllerState({
    this.isRunning = false,
    this.isBusy = false,
    this.connectedClients = const [],
  });

  final bool isRunning;
  final bool isBusy;
  final List<ClientInfo> connectedClients;

  RemoteControllerState copyWith({
    bool? isRunning,
    bool? isBusy,
    List<ClientInfo>? connectedClients,
  }) {
    return RemoteControllerState(
      isRunning: isRunning ?? this.isRunning,
      isBusy: isBusy ?? this.isBusy,
      connectedClients: connectedClients ?? this.connectedClients,
    );
  }

  @override
  List<Object?> get props => [isRunning, isBusy, connectedClients];
}
