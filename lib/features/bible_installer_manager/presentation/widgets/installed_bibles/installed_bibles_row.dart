part of 'installed_bibles_section.dart';

class _InstalledBiblesRow extends StatelessWidget {
  final BibleMeta bibleMeta;

  const _InstalledBiblesRow({required this.bibleMeta});

  @override
  Widget build(BuildContext context) {
    return HoverableContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      height: 36,
      initialColor: null,
      hoveredColor: Theme.of(context).colorScheme.primaryContainer,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: Text(
                bibleMeta.bibleName.split("\\").last,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                bibleMeta.langEngName ?? 'uknown',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () => context
                  .read<InstalledBiblesBloc>()
                  .add(InstalledBiblesUninstall(bibleMeta.extId)),
              child: Row(
                spacing: 8,
                children: [
                  const Icon(Icons.delete_forever_outlined),
                  const Text('Uninstall'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
