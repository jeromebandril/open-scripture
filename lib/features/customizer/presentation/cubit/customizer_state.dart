part of 'customizer_cubit.dart';

class CustomizerState extends Equatable {
  const CustomizerState({
    this.version = 1,
    this.app = const AppThemeSettings(),
    this.pane = const BiblePaneThemeSettings(),
  });

  final int version;
  final AppThemeSettings app;
  final BiblePaneThemeSettings pane;

  CustomizerState copyWith({
    int? version,
    AppThemeSettings? app,
    BiblePaneThemeSettings? pane,
  }) {
    return CustomizerState(
      version: version ?? this.version,
      app: app ?? this.app,
      pane: pane ?? this.pane,
    );
  }

  @override
  List<Object?> get props => [version, app, pane];

  Map<String, dynamic> toJson() => {
        'version': version,
        'app': app.toJson(),
        'pane': pane.toJson(),
      };

  static CustomizerState fromJson(Map<String, dynamic> json) {
    return CustomizerState(
      version: (json['version'] as int?) ?? 1,
      app: AppThemeSettings.fromJson(
        (json['app'] as Map<String, dynamic>?) ?? const {},
      ),
      pane: BiblePaneThemeSettings.fromJson(
        (json['pane'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }
}
