part of 'remote_catalog_section.dart';

class RemoteCatalogRow extends StatelessWidget {
  final int index;
  final BibleMeta bibleMeta;

  const RemoteCatalogRow({
    super.key,
    required this.bibleMeta,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final id = bibleMeta.abbreviation; // ideally remoteId
    final progress = context.select(
      (DownloadManagerBloc b) => b.state.progressByBibleId[id],
    );

    final isBusy = progress != null &&
        progress.stage != InstallStage.done &&
        progress.stage != InstallStage.failed;

    return HoverableContainer(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      initialColor: Theme.of(context).colorScheme.surface,
      hoveredColor: Theme.of(context).colorScheme.primaryContainer,
      child: Row(children: [
        SizedBox(
          width: 40,
          child: Text('$index', textAlign: TextAlign.end),
        ),
        const VerticalDivider(),
        Expanded(
            child:
                Text(bibleMeta.abbreviation, overflow: TextOverflow.ellipsis)),
        const VerticalDivider(),
        Expanded(
          flex: 2,
          child:
              Text(bibleMeta.bibleNameLocal, overflow: TextOverflow.ellipsis),
        ),
        const VerticalDivider(),
        Expanded(
          flex: 2,
          child: Text(
            bibleMeta.langEngName ?? 'Unknown',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const VerticalDivider(),
        Expanded(
          flex: 2,
          child: bibleMeta.isAlreadyInstalled
              ? Text('Installed 👍', textAlign: TextAlign.center)
              : isBusy
                  ? _DownloadingProgressBar(bible: bibleMeta)
                  : _DownloadButton(
                      onPressed: () => context
                          .read<DownloadManagerBloc>()
                          .add(StartInstall(id)),
                    ),
        ),
      ]),
    );
  }
}

class _DownloadButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _DownloadButton({required this.onPressed});

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TextButton(
        onPressed: widget.onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_hovered) ...[
              const Icon(Icons.download, size: 16),
              const SizedBox(width: 6),
            ],
            const Text('Download', maxLines: 1),
          ],
        ),
      ),
    );
  }
}

class _DownloadingProgressBar extends StatefulWidget {
  final BibleMeta bible;
  const _DownloadingProgressBar({required this.bible});

  @override
  State<_DownloadingProgressBar> createState() =>
      _DownloadingProgressBarState();
}

class _DownloadingProgressBarState extends State<_DownloadingProgressBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadManagerBloc, DownloadManagerState>(
        builder: (context, state) {
      final progress = state.progressByBibleId[widget.bible.abbreviation]!;
      return Row(children: [
        IconButton(
          onPressed: () {},
          // onPressed: () => togglePauseDownload(
          //   context,
          //   state.progress!,
          // ),
          icon: Icon(
            progress.stage == InstallStage.paused
                ? Icons.play_arrow_rounded
                : Icons.pause_rounded,
          ),
          padding: EdgeInsets.zero,
        ),
        Expanded(
            child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            LinearProgressIndicator(
              minHeight: 20,
              value: progress.stage == InstallStage.done ||
                      progress.stage == InstallStage.installing
                  ? 1
                  : progress.fraction,
            ),
            Text(
              "${progress.received}/${progress.total}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12, color: Theme.of(context).colorScheme.onPrimary),
            ),
          ],
        )),
      ]);
    });
  }
}
