part of 'installer_bloc.dart';

sealed class InstallerEvent extends Equatable {
  const InstallerEvent();

  @override
  List<Object?> get props => [];
}

final class InstalledBiblesSubscriptionRequested extends InstallerEvent {}

final class InstalledBiblesLoad extends InstallerEvent {}

final class InstalledBiblesUninstall extends InstallerEvent {
  final String id;

  const InstalledBiblesUninstall(this.id);

  @override
  List<Object> get props => [id];
}

final class InstalledBiblesSelect extends InstallerEvent {
  final String? selectedId;

  const InstalledBiblesSelect({required this.selectedId});

  @override
  List<Object?> get props => [selectedId];
}
