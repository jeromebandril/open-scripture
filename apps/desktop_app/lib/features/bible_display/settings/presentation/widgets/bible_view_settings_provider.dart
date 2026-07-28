import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/settings/settings_cubit.dart';
import '../../bible_view_settings.dart';

/// This is how I inject theming and settings tha affect UI
/// for bible views
class BibleViewSettingsProvider extends StatelessWidget {
  const BibleViewSettingsProvider({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit<BibleViewSettings>, BibleViewSettings>(
      builder: (context, settings) =>
          BibleViewSettingsScope(settings: settings, child: child),
    );
  }
}

class BibleViewSettingsScope extends InheritedWidget {
  const BibleViewSettingsScope({
    super.key,
    required this.settings,
    required super.child,
  });

  final BibleViewSettings settings;

  static BibleViewSettings of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<BibleViewSettingsScope>();
    assert(
        scope != null, 'No BibleViewSettingsScope found above this context.');
    return scope!.settings;
  }

  @override
  bool updateShouldNotify(BibleViewSettingsScope oldWidget) =>
      settings != oldWidget.settings;
}
