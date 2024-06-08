import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:the_smyrna_bible_v2/core/widgets/hoverable_container.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/entities/translation_info.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/presentation/bloc/translation_download_progress/translation_download_progress_bloc.dart';
import 'package:the_smyrna_bible_v2/injection_container.dart';
import 'package:collection/collection.dart';

import '../bloc/translations_overview/translations_bloc.dart';
import '../bloc/installed_translations_overview/installed_translations_bloc.dart';

class SectionHeader extends StatelessWidget {
  final String text;
  const SectionHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// OVERVIEWS

class TranslationManagerWidget extends StatelessWidget {
  const TranslationManagerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AllTranslationsBloc>()
            ..add(AllTranslationsSubscriptionRequested()),
        ),
        BlocProvider(
          create: (_) => sl<TranslationDownloadProgressBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<InstalledTranslationsBloc>()
            ..add(InstalledTranslationsSubscriptionRequested()),
        ),
      ],
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: AllTranslationsOverview(),
            ),
            Gap(8),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: DownloadingTranslationsOverview()),
                  Gap(8),
                  Expanded(child: InstalledTranslationOverview()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
  All translation overview will have a first layer of filtering
  with an expandable sections based on language (es: italian, english, and 
  each section will reaveal all the bible in that language) using [ExpandableTile]
*/
class AllTranslationsOverview extends StatelessWidget {
  const AllTranslationsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const SectionHeader('All TRANSLATIONS AVAILABLE'),
          Expanded(
            child: BlocBuilder<AllTranslationsBloc, AllTranslationsState>(
              builder: (context, state) {
                // error feedbacks
                if (state.translationInfos.isEmpty) {
                  if (state.status == AllTranslationsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == AllTranslationsStatus.error) {
                    return Center(child: Text(state.errorMessage ?? 'Error'));
                  }
                }

                // successful (group by language)
                var map = groupBy<TranslationInfo, String>(
                  state.translationInfos,
                  (info) => info.language,
                );

                return ListView.builder(
                  addAutomaticKeepAlives: true,
                  itemCount: map.values.length,
                  itemBuilder: (_, index) {
                    String key = map.keys.elementAt(index);
                    List<AllTranslationsTile> tiles = [];
                    int groupIndex = 1;
                    for (var info in map[key]!) {
                      tiles.add(
                        AllTranslationsTile(
                          translationInfo: info,
                          index: groupIndex,
                        ),
                      );
                      groupIndex++;
                    }
                    return ExpandableTile(
                      title: "$key (${tiles.length})",
                      tiles: tiles,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DownloadingTranslationsOverview extends StatelessWidget {
  const DownloadingTranslationsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const SectionHeader('DOWNLOAD QUEUE'),
          Expanded(
            child: BlocBuilder<TranslationDownloadProgressBloc,
                TranslationDownloadProgressState>(
              builder: (context, state) {
                //final list = state.getDownloadingList();
                final list = state.downloadingTranslations.entries.toList();
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    return DownloadingOverviewTile(
                      translationInfo: list[index].value,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InstalledTranslationOverview extends StatelessWidget {
  const InstalledTranslationOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const SectionHeader('INSTALLED'),
          Expanded(
            child: BlocBuilder<InstalledTranslationsBloc,
                InstalledTranslationsState>(
              builder: (context, state) {
                switch (state.status) {
                  case InstalledTranslationsStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case InstalledTranslationsStatus.loaded:
                    return ListView.builder(
                      itemCount: state.installedTranslations.length,
                      itemBuilder: (_, index) {
                        return InstalledTranslationsOverviewTile(
                          translationInfo: state.installedTranslations[index],
                        );
                      },
                    );

                  default:
                    return Text(state.toString());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// SPECIFIC OVERVIEW TILES TYPES

class DownloadingOverviewTile extends StatefulWidget {
  final TranslationInfo translationInfo;
  const DownloadingOverviewTile({super.key, required this.translationInfo});

  @override
  State<DownloadingOverviewTile> createState() =>
      _DownloadingOverviewTileState();
}

class _DownloadingOverviewTileState extends State<DownloadingOverviewTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return HoverableContainer(
      onEnter: () => setState(() {
        _hovered = true;
      }),
      onExit: () => setState(() {
        _hovered = false;
      }),
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      initialColor: null,
      hoveredColor: Colors.grey.shade400,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              widget.translationInfo.id,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              widget.translationInfo.received.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              widget.translationInfo.total.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.translationInfo.downloadStatus !=
              DownloadStatus.downloaded)
            IconButton(
              onPressed: () => togglePauseDownload(
                context,
                widget.translationInfo,
              ),
              icon: Icon(
                widget.translationInfo.downloadStatus == DownloadStatus.paused
                    ? Icons.play_arrow_rounded
                    : Icons.pause_rounded,
              ),
              padding: EdgeInsets.zero,
            ),
          Expanded(
            child: _hovered
                ? TextButton(
                    onPressed: () {},
                    child:
                        Text(widget.translationInfo.downloadStatus.toString()),
                  )
                : Column(
                    children: [
                      Text(
                        widget.translationInfo.downloadStatus.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      LinearProgressIndicator(
                        value: widget.translationInfo.downloadStatus ==
                                    DownloadStatus.installed ||
                                widget.translationInfo.downloadStatus ==
                                    DownloadStatus.installing
                            ? 1
                            : widget.translationInfo.received /
                                widget.translationInfo.total,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void togglePauseDownload(ctx, TranslationInfo translationInfo) {
    BlocProvider.of<TranslationDownloadProgressBloc>(context).add(
      translationInfo.downloadStatus == DownloadStatus.paused
          ? TranslationDownloadProgressResume(translationInfo.id)
          : TranslationDownloadProgressPause(translationInfo.id),
    );
  }
}

class AllTranslationsTile extends StatefulWidget {
  final int index;
  final TranslationInfo translationInfo;

  const AllTranslationsTile({
    super.key,
    required this.translationInfo,
    required this.index,
  });

  @override
  State<AllTranslationsTile> createState() => _AllTranslationsTileState();
}

class _AllTranslationsTileState extends State<AllTranslationsTile> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(
          false), //widget.translationInfo.checkIfAlreadyInstalled(),
      builder: (_, snapshot) {
        bool isAlreadyInstalled = snapshot.hasData && snapshot.data!;

        return HoverableContainer(
          onEnter: () => setState(() {
            _visible = true;
          }),
          onExit: () => setState(() {
            _visible = false;
          }),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          initialColor: isAlreadyInstalled ||
                  widget.translationInfo.downloadStatus ==
                      DownloadStatus.downloading
              ? Colors.grey.shade100
              : null,
          hoveredColor: Colors.grey.shade200,
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text('${widget.index}'),
              ),
              const VerticalDivider(),
              Expanded(
                child: Text(
                  widget.translationInfo.id,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const VerticalDivider(),
              Expanded(
                flex: 2,
                child: Text(
                  widget.translationInfo.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const VerticalDivider(),
              Expanded(
                flex: 2,
                child: Text(
                  widget.translationInfo.language,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const VerticalDivider(),
              Expanded(
                flex: 2,
                child: Visibility.maintain(
                  visible: _visible ||
                      isAlreadyInstalled ||
                      widget.translationInfo.downloadStatus ==
                          DownloadStatus.downloading,
                  child: TextButton(
                    onPressed: isAlreadyInstalled ||
                            widget.translationInfo.downloadStatus ==
                                DownloadStatus.downloading
                        ? null
                        : () => dispatch(context, widget.translationInfo.id),
                    child: Text(
                      isAlreadyInstalled
                          ? 'Installed'
                          : widget.translationInfo.downloadStatus ==
                                  DownloadStatus.downloading
                              ? 'Downloading...'
                              : 'Download',
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void dispatch(context, String id) {
    BlocProvider.of<TranslationDownloadProgressBloc>(context).add(
      TranslationDownloadProgressPressed(id),
    );
  }
}

class InstalledTranslationsOverviewTile extends StatelessWidget {
  final TranslationInfo translationInfo;

  const InstalledTranslationsOverviewTile({
    super.key,
    required this.translationInfo,
  });

  @override
  Widget build(BuildContext context) {
    return HoverableContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      height: 36,
      initialColor: null,
      hoveredColor: Colors.grey.shade400,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                translationInfo.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Uninstall'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandableTile extends StatefulWidget {
  final String title;
  final List<Widget> tiles;

  const ExpandableTile({
    required this.title,
    required this.tiles,
    super.key,
  });

  @override
  State<ExpandableTile> createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HoverableContainer(
          height: 40,
          hoveredColor: const Color.fromRGBO(175, 193, 175, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title),
              IconButton(
                onPressed: () => setState(() => isExpand = !isExpand),
                icon: const Icon(Icons.arrow_drop_down_circle_sharp),
              )
            ],
          ),
        ),
        Visibility(
          visible: isExpand,
          child: Container(
            color: Colors.grey.shade200,
            child: Column(
              children: widget.tiles,
            ),
          ),
        ),
      ],
    );
  }
}
