import 'package:flutter/material.dart';
import 'package:open_scripture/shared/design_system/tokens/tokens.dart';
import 'package:url_launcher/url_launcher.dart';

class ListOfBibleRepositories extends StatelessWidget {
  const ListOfBibleRepositories({
    super.key,
    required this.urls,
    required this.description,
  });

  final List<String> urls;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Text(description),
        Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xs,
            children: urls
                .map(
                  (e) => Material(
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      mouseCursor: SystemMouseCursors.click,
                      hoverColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      onTap: () async => await launchUrl(Uri.parse(e)),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                            // color: Theme.of(context).colorScheme.surfaceContainer,
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e),
                            Icon(
                              Icons.open_in_new,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList()),
      ],
    );
  }
}
