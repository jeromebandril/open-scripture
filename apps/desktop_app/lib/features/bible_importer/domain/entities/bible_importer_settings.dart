class BibleImporterSettings {
  final String swordInstallationPath;

  const BibleImporterSettings({required this.swordInstallationPath});

  Map<String, dynamic> toJson() => {
        'sword_installation_path': swordInstallationPath,
      };

  factory BibleImporterSettings.fromJson(Map<String, dynamic> json) {
    return BibleImporterSettings(
      swordInstallationPath: json['sword_installation_path'] as String? ?? '',
    );
  }

  BibleImporterSettings copyWith({String? swordInstallationPath}) {
    return BibleImporterSettings(
      swordInstallationPath:
          swordInstallationPath ?? this.swordInstallationPath,
    );
  }
}
