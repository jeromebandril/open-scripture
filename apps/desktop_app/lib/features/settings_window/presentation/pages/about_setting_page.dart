import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/design_system/tokens/tokens.dart';
import '../../../../shared/utils/platform_info.dart';
import '../../../../shared/widgets/inline_link_button.dart';
import '../widgets/setting_section.dart';

class AboutSettingsPage extends StatelessWidget {
  static const _repoUrl = 'https://github.com/jeromebandril/open-scripture';

  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedTextStyle = TextStyle(
      fontSize: 12,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );
    final valueTextStyle = const TextStyle(fontSize: 12);
    final monoTextStyle = const TextStyle(
      fontSize: 11.5,
      fontFamily: 'monospace',
    );

    return FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox();

          final info = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.fromLTRB(42, 0, 42, 42),
            child: Column(
              spacing: AppSpacing.xl,
              children: [
                SettingSection.single(
                  title: 'About',
                  child: _AppCard(info: info),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --------------------------------------
                    // Description List
                    // --------------------------------------
                    Table(
                      columnWidths: const {
                        0: FixedColumnWidth(110.0),
                        1: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        _buildTableRow(
                          label: 'Build',
                          labelStyle: mutedTextStyle,
                          child: Text(
                            '${getTargetPlatform()} - v${info.version} (${info.buildNumber})',
                            style: monoTextStyle,
                          ),
                        ),
                        _buildTableRow(
                          label: 'Package name',
                          labelStyle: mutedTextStyle,
                          child: Text(
                            info.packageName,
                            style: monoTextStyle,
                          ),
                        ),
                        _buildTableRow(
                          label: 'License',
                          labelStyle: mutedTextStyle,
                          child: Text('Apache 2.0', style: valueTextStyle),
                        ),
                        _buildTableRow(
                          label: 'Source code',
                          labelStyle: mutedTextStyle,
                          child: InlineLinkButton(
                            icon: LucideIcons.code,
                            label: 'jeromebandril/open-scripture',
                            onPressed: openGithub,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // --------------------------------------------
                    // Action Controls
                    // --------------------------------------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            OutlinedButton.icon(
                              onPressed: openGithub,
                              icon: const Icon(Icons.code, size: 14),
                              label: const Text('View on GitHub'),
                              style: OutlinedButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            TextButton(
                              onPressed: null,
                              style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                              ),
                              child: const Text('Report an issue'),
                            ),
                            TextButton(
                              onPressed: null,
                              style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                              ),
                              child: const Text('Suggest ideas'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void openGithub() async {
    final Uri url = Uri.parse(_repoUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  TableRow _buildTableRow({
    required String label,
    required TextStyle labelStyle,
    required Widget child,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(label, style: labelStyle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: child,
        ),
      ],
    );
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
            const Text('Reading and presenting scripture for church services'),
            const SizedBox(height: AppSpacing.xs),
            Text(info.version)
          ],
        )
      ],
    );
  }
}
