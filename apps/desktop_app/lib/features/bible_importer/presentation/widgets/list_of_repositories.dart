import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/design_system/tokens/tokens.dart';
import '../../../../shared/enums/bible_repository_type.dart';
import '../models/bible_source.dart';

class ListOfBibleRepositories extends StatelessWidget {
  static const _recommendedSources = [
    BibleSource(
      name: 'eBible.org',
      url: 'https://ebible.org/download.php',
      description:
          'Large collection of public domain and freely licensed translations. Download USFX files from here.',
      repoType: BibleRepositoryType.localDatabase,
    ),
    BibleSource(
      name: 'seven1m/open-bibles',
      url: 'https://github.com/seven1m/open-bibles',
      description:
          'Open bibles in various formats (GitHub). Download OSIS files from here.',
      repoType: BibleRepositoryType.localDatabase,
    ),
    BibleSource(
      name: 'crosswire sword bibles',
      url: 'https://www.crosswire.org/sword/modules/ModDisp.jsp?modType=Bibles',
      description:
          'Official crosswire bible repository. Download SWORD modules from here.',
      repoType: BibleRepositoryType.sword,
    ),
    BibleSource(
      name: 'crosswire sword bibles (ftp)',
      url:
          'https://ftp.crosswire.org/ftpmirror/pub/sword/raw/modules/texts/ztext',
      description:
          'Official crosswire bible repository (ftp mirror). Download SWORD modules from here.',
      repoType: BibleRepositoryType.sword,
    ),
  ];

  const ListOfBibleRepositories({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xl,
      children: [
        Text(
          'The links below point to third-party websites and repositories that are not '
          'affiliated with, maintained by, or endorsed by this app. They are provided as a '
          'convenience to help you find Bible texts to import.',
          style: textTheme.bodyMedium,
        ),
        ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
            itemCount: _recommendedSources.length,
            itemBuilder: (context, index) {
              final src = _recommendedSources[index];

              return Card(
                child: ListTile(
                  title: Text(src.name, style: textTheme.labelMedium),
                  subtitle: Text(src.description, style: textTheme.bodySmall),
                  trailing: const Icon(LucideIcons.externalLink),
                  onTap: () async => await launchUrl(Uri.parse(src.url)),
                ),
              );
            }),
        Text(
          '* Each source has its own licensing terms — some texts are public domain, others are '
          'freely redistributable, and some may have restrictions on further redistribution or '
          'commercial use.'
          'This app does not host, distribute, or verify the content of these external sources, '
          'and is not responsible for their availability, accuracy, or terms of use.',
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}
