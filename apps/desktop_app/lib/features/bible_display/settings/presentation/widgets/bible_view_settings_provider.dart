import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../core/settings/settings_cubit.dart';
import '../../../colorschemes/domain/entities/bible_view_colorscheme.dart';
import '../../../colorschemes/presentation/cubit/colorscheme_cubit.dart';
import '../../bible_view_settings.dart';
// import '.../bible_view_colorscheme.dart';
// import '.../colorschemes_cubit.dart';

/// This is how I inject theming and settings that affect UI
/// for bible views.
///
/// Both sources of truth are cubits provided at the app root:
///   - SettingsCubit<BibleViewSettings>  -> which colorscheme (by name)
///   - ColorschemesCubit                 -> presets + custom colorschemes
///
/// The colorscheme is resolved here, once per change of either, and exposed
/// through the scope. Mount this provider at the app root (under your
/// MultiBlocProvider, above MaterialApp) so it is also available outside the
/// bible view, e.g. in settings pages and dialogs.
class BibleViewSettingsProvider extends StatelessWidget {
  const BibleViewSettingsProvider({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ColorschemesCubit>()..load()),
        BlocProvider(create: (_) => di.sl<SettingsCubit<BibleViewSettings>>()),
      ],
      child: BlocBuilder<SettingsCubit<BibleViewSettings>, BibleViewSettings>(
        builder: (context, settings) {
          return BlocBuilder<ColorschemesCubit, ColorschemesState>(
            builder: (context, colorschemes) => BibleViewSettingsScope(
              settings: settings,
              colorscheme: BibleViewColorscheme.resolve(
                settings.colorschemeName,
                colorschemes.all,
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class BibleViewSettingsScope extends InheritedWidget {
  const BibleViewSettingsScope({
    super.key,
    required this.settings,
    required this.colorscheme,
    required super.child,
  });

  final BibleViewSettings settings;
  final BibleViewColorscheme colorscheme;

  static BibleViewSettingsScope _scope(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<BibleViewSettingsScope>();
    assert(
        scope != null, 'No BibleViewSettingsScope found above this context.');
    return scope!;
  }

  static BibleViewSettings of(BuildContext context) => _scope(context).settings;

  static BibleViewColorscheme colorschemeOf(BuildContext context) =>
      _scope(context).colorscheme;

  /// Like [colorschemeOf] but does NOT subscribe to changes.
  /// Use it for a one-time read.
  static BibleViewColorscheme readColorscheme(BuildContext context) {
    final scope =
        context.getInheritedWidgetOfExactType<BibleViewSettingsScope>();
    assert(
        scope != null, 'No BibleViewSettingsScope found above this context.');
    return scope!.colorscheme;
  }

  @override
  bool updateShouldNotify(BibleViewSettingsScope oldWidget) =>
      settings != oldWidget.settings || colorscheme != oldWidget.colorscheme;
}

// extension BibleViewColorschemeContext on BuildContext {
//   /// The colorscheme currently used by the bible view:
//   /// `context.bibleColors.verseDividerColor`
//   BibleViewColorscheme get bibleColors =>
//       BibleViewSettingsScope.colorschemeOf(this);
// }
