part of 'customizer_cubit.dart';

class CustomizerState extends Equatable {
  const CustomizerState({
    this.version = 1,
    this.app = const AppThemeSettings(),
    this.pane = const BiblePaneGeneralThemeSettings(),
    this.presentTheme = const BibleViewPresentationThemeSettings(),
    this.listTheme = const BibleViewListThemeSettings(),
    this.proseTheme = const BibleViewProseThemeSettings(),
  });

  final int version;
  final AppThemeSettings app;
  final BiblePaneGeneralThemeSettings pane;
  final BibleViewPresentationThemeSettings presentTheme;
  final BibleViewListThemeSettings listTheme;
  final BibleViewProseThemeSettings proseTheme;

  CustomizerState copyWith({
    int? version,
    AppThemeSettings? app,
    BiblePaneGeneralThemeSettings? pane,
    BibleViewPresentationThemeSettings? presentationTheme,
    BibleViewListThemeSettings? listTheme,
    BibleViewProseThemeSettings? proseTheme,
  }) {
    return CustomizerState(
      version: version ?? this.version,
      app: app ?? this.app,
      pane: pane ?? this.pane,
      presentTheme: presentationTheme ?? presentTheme,
      listTheme: listTheme ?? this.listTheme,
      proseTheme: proseTheme ?? this.proseTheme,
    );
  }

  @override
  List<Object?> get props =>
      [version, app, pane, presentTheme, listTheme, proseTheme];

  Map<String, dynamic> toJson() => {
        'version': version,
        'app': app.toJson(),
        'pane': pane.toJson(),
        'presentView': presentTheme.toJson(),
        'listView': listTheme.toJson(),
        'proseView': proseTheme.toJson(),
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
      listTheme: BibleViewListThemeSettings.fromJson(
        (json['listView'] as Map<String, dynamic>?) ?? const {},
      ),
      proseTheme: BibleViewProseThemeSettings.fromJson(
        (json['proseView'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }
}
