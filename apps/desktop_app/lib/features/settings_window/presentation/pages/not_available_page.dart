import 'package:flutter/material.dart';

import '../../../../shared/design_system/tokens/spacing.dart';
import '../../../../shared/utils/platform_info.dart';

// For now It is ok to have hardcoded strings, because
// the only platform supported are web and windows,
// and the latter supports all features
class FeatureNotAvailablePage extends StatelessWidget {
  const FeatureNotAvailablePage({
    super.key,
    this.featureDescription,
  });

  final String? featureDescription;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Text(
            'This feature is not available on ${getTargetPlatform()}',
            textAlign: TextAlign.center,
            style: textTheme.titleSmall,
          ),
          if (featureDescription != null)
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Description: ',
                    style: textTheme.labelMedium,
                  ),
                  TextSpan(
                    text: featureDescription!,
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Supported platforms: ',
                  style: textTheme.labelMedium,
                ),
                TextSpan(
                  text: 'Windows',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
            textAlign: TextAlign.left,
          )
        ],
      ),
    );
  }
}
