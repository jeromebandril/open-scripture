part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsGotoPage extends SettingsEvent {
  final String pageName;

  const SettingsGotoPage(this.pageName);

  @override
  List<Object> get props => [pageName];
}
