import 'package:flutter/material.dart';

import '../../shared/design_system/design_system.dart';
import '../widgets/app_window.dart';
import '../widgets/titlebar.dart';

extension AppBuildContextExtensions on BuildContext {
  Future<T?> pushWindow<T>({
    required WidgetBuilder builder,
  }) {
    return Navigator.of(this, rootNavigator: true).push(
      DialogRoute<T>(
        context: this,
        barrierDismissible: false,
        barrierColor: const Color(0x99000000),
        builder: (context) {
          return Column(
            children: [
              const Titlebar(showMenuBar: false),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl2),
                    child: Material(
                      elevation: 24,
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: builder(context),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<T?> pushStandardWindow<T>({
    required String title,
    required Size maxSize,
    required WidgetBuilder builder,
  }) {
    return pushWindow<T>(
      builder: (context) {
        return AppWindow(
          title: title,
          maxSize: maxSize,
          child: builder(context),
        );
      },
    );
  }

  void closeWindow<T>([T? result]) {
    Navigator.of(this).pop(result);
  }
}
