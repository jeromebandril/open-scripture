import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../shared/design_system/tokens/tokens.dart';
import '../../../../shared/utils/platform_info.dart';
import '../widgets/setting_section.dart';

class AboutSettingsPage extends StatelessWidget {
  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox();

          final info = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.fromLTRB(42, 0, 42, 42),
            child: Column(
              spacing: AppSpacing.lg,
              children: [
                SettingSection.single(
                    title: 'About', child: _AppCard(info: info)),
                Row(
                  spacing: AppSpacing.xl,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Build'),
                        Text('Package name'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${getTargetPlatform()} - v${info.version} (${info.buildNumber})'),
                        Text(info.packageName),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}

class _AppCard extends StatelessWidget {
  const _AppCard({required this.info});

  final PackageInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      spacing: AppSpacing.lg,
      children: [
        Container(
          width: 48,
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Image.asset(
            'assets/icon/icon.png',
            width: 48,
            height: 48,
            filterQuality: FilterQuality.high,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.appName, style: theme.textTheme.labelLarge),
            const Text(
                'Reading and presenting scripture during church services'),
            const SizedBox(height: AppSpacing.xs),
            Text(info.version)
          ],
        )
      ],
    );
  }
}
