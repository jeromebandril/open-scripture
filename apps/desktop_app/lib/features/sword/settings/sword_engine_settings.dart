// TODO: fix DI injection because this is called twice
class SwordEngineSettings {
  final String modulesPath;

  const SwordEngineSettings({required this.modulesPath});

  Map<String, dynamic> toJson() => {
        'modules_path': modulesPath,
      };

  factory SwordEngineSettings.fromJson(Map<String, dynamic> json) {
    return SwordEngineSettings(
      modulesPath: json['modules_path'] as String? ?? '',
    );
  }

  SwordEngineSettings copyWith({String? modulesPath}) {
    return SwordEngineSettings(
      modulesPath: modulesPath ?? this.modulesPath,
    );
  }
}
