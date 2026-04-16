part of 'installed_bibles_bloc.dart';

sealed class InstalledBiblesEvent extends Equatable {
  const InstalledBiblesEvent();

  @override
  List<Object?> get props => [];
}

final class InstalledBiblesSubscriptionRequested extends InstalledBiblesEvent {}

final class InstalledBiblesLoad extends InstalledBiblesEvent {}

final class InstalledBiblesUninstall extends InstalledBiblesEvent {
  final String id;

  const InstalledBiblesUninstall(this.id);

  @override
  List<Object> get props => [id];
}

final class InstalledBiblesSelect extends InstalledBiblesEvent {
  final String? selectedId;

  const InstalledBiblesSelect({required this.selectedId});

  @override
  List<Object?> get props => [selectedId];
}
