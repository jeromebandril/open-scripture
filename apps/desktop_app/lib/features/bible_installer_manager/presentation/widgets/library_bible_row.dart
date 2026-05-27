part of '../pages/library_manager_page.dart';

class _InstalledBiblesRow extends StatelessWidget {
  final BibleMeta bibleMeta;
  final bool isSelected;

  const _InstalledBiblesRow({
    required this.bibleMeta,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return HoverableContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.transparent,
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
                  .read<InstallerBloc>()
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
