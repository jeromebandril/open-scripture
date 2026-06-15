part of 'bible_importer_settings_cubit.dart';

final class BibleImporterSettingsState extends Equatable {
  const BibleImporterSettingsState({
    this.settings = const BibleImporterSettings(swordInstallationPath: ''),
  });

  final BibleImporterSettings settings;

  @override
  List<Object?> get props => [];
}
