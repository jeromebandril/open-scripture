part of 'colorscheme_cubit.dart';

class ColorschemesState extends Equatable {
  ColorschemesState({this.custom = const [], this.isLoaded = false});

  /// The user's custom colorschemes, loaded from storage.
  final List<BibleViewColorscheme> custom;

  /// False until the custom colorschemes were read from storage. Until then a
  /// saved `custom_xxx` name can't be resolved and would show the default
  /// theme for a moment, so gate the first frame on this (or load before
  /// runApp).
  final bool isLoaded;

  /// Presets + custom, merged once per state instance (not on every read).
  /// Feed this to `BibleViewColorscheme.resolve` and to ColorschemeSelector.
  late final List<BibleViewColorscheme> all = [
    ...kBibleViewColorschemePresets,
    ...custom,
  ];

  ColorschemesState copyWith({
    List<BibleViewColorscheme>? custom,
    bool? isLoaded,
  }) =>
      ColorschemesState(
        custom: custom ?? this.custom,
        isLoaded: isLoaded ?? this.isLoaded,
      );

  @override
  List<Object?> get props => [custom, isLoaded];
}
