part of 'customizer_cubit.dart';

class CustomizerState extends Equatable {
  const CustomizerState({
    this.version = 1,
    this.app = const AppThemeSettings(),
    this.pane = const BiblePaneGeneralThemeSettings(),
    this.presentTheme = const BibleViewPresentationThemeSettings(),
  });

  final int version;
  final AppThemeSettings app;
  final BiblePaneGeneralThemeSettings pane;
  final BibleViewPresentationThemeSettings presentTheme;

  CustomizerState copyWith({
    int? version,
    AppThemeSettings? app,
    BiblePaneGeneralThemeSettings? pane,
    BibleViewPresentationThemeSettings? presentationTheme,
  }) {
    return CustomizerState(
      version: version ?? this.version,
      app: app ?? this.app,
      pane: pane ?? this.pane,
      presentTheme: presentationTheme ?? this.presentTheme,
    );
  }

  @override
  List<Object?> get props => [version, app, pane, presentTheme];

  Map<String, dynamic> toJson() => {
        'version': version,
        'app': app.toJson(),
        'pane': pane.toJson(),
        'presentView': presentTheme.toJson(),
      };

  static CustomizerState fromJson(Map<String, dynamic> json) {
    return CustomizerState(
      version: (json['version'] as int?) ?? 1,
      app: AppThemeSettings.fromJson(
        (json['app'] as Map<String, dynamic>?) ?? const {},
      ),
      pane: BiblePaneGeneralThemeSettings.fromJson(
        (json['pane'] as Map<String, dynamic>?) ?? const {},
      ),
      presentTheme: BibleViewPresentationThemeSettings.fromJson(
        (json['presentView'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }
}
