part of 'bible_importer_settings_cubit.dart';

enum BibleImporterSettingsStatus {
  init,
  ready,
  error,
  loading,
}

final class BibleImporterSettingsState extends Equatable {
  const BibleImporterSettingsState({
    this.settings = const BibleImporterSettings(swordInstallationPath: ''),
    this.error,
    this.status = BibleImporterSettingsStatus.init,
  });

  final BibleImporterSettings settings;
  final String? error;
  final BibleImporterSettingsStatus status;

  BibleImporterSettingsState copyWith({
    BibleImporterSettings? settings,
    String? Function()? error,
    BibleImporterSettingsStatus? status,
  }) {
    return BibleImporterSettingsState(
      settings: settings ?? this.settings,
      error: error != null ? error() : this.error,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [settings, error, status];
}
