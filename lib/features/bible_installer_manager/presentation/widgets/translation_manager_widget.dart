import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/e_bible.dart';
import 'package:the_smyrna_bible_v2/core/presentation/widgets/hoverable_container.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/domain/entities/bible_download_progress.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/presentation/bloc/bible_download_progress/bible_download_progress_bloc.dart';
import 'package:the_smyrna_bible_v2/injection_container.dart';
import 'package:collection/collection.dart';

import '../bloc/installed_bibles_overview/installed_bibles_bloc.dart';
import '../bloc/translations_overview/translations_bloc.dart';

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

class BibleDownloadManagerWidget extends StatelessWidget {
  const BibleDownloadManagerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => sl<AllTranslationsBloc>()
              ..add(AllBiblesSubscriptionRequested())),
        BlocProvider(
            create: (_) => sl<InstalledBiblesBloc>()
              ..add(InstalledBiblesSubscriptionRequested())),
      ],
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: AllDownloadableBiblesOverview(),
            ),
            Gap(8),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: AllInstalledBiblesOverview()),
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
class AllDownloadableBiblesOverview extends StatelessWidget {
  const AllDownloadableBiblesOverview({super.key});

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
                if (state.bibles.isEmpty) {
                  if (state.status == AllTranslationsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == AllTranslationsStatus.error) {
                    return Center(child: Text(state.errorMessage ?? 'Error'));
                  }
                }

                // successful (group by language)
                var map = groupBy<EBible, String>(
                  state.bibles,
                  (info) => info.langEngName ?? '',
                );

                return ListView.builder(
                  addAutomaticKeepAlives: true,
                  itemCount: map.values.length,
                  itemBuilder: (_, index) {
                    String key = map.keys.elementAt(index);
                    List<AllBiblesTile> tiles = [];
                    int groupIndex = 1;
                    for (var info in map[key]!) {
                      tiles.add(
                        AllBiblesTile(
                          bible: info,
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

class AllInstalledBiblesOverview extends StatelessWidget {
  const AllInstalledBiblesOverview({super.key});

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
            child: BlocBuilder<InstalledBiblesBloc, InstalledBiblesState>(
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
  final EBible bible;
  const DownloadingOverviewTile({super.key, required this.bible});

  @override
  State<DownloadingOverviewTile> createState() =>
      _DownloadingOverviewTileState();
}

class _DownloadingOverviewTileState extends State<DownloadingOverviewTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BibleDownloadProgressBloc>()
        ..add(BibleDownloadProgressPressed(widget.bible)),
      child: HoverableContainer(
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
        child:
            BlocBuilder<BibleDownloadProgressBloc, BibleDownloadProgressState>(
          builder: (context, state) {
            if (state.progress == null) {
              return SizedBox(
                child: Text("null!!"),
              );
            }

            print('${state.progress!.received}/${state.progress!.total}');

            return Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    widget.bible.bibleName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    state.progress!.received.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    state.progress!.total.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (state.progress!.downloadStatus != DownloadStatus.downloaded)
                  IconButton(
                    onPressed: () {},
                    // onPressed: () => togglePauseDownload(
                    //   context,
                    //   state.progress!,
                    // ),
                    icon: Icon(
                      state.progress!.downloadStatus == DownloadStatus.paused
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
                              Text(state.progress!.downloadStatus.toString()),
                        )
                      : Column(
                          children: [
                            Text(
                              state.progress!.downloadStatus.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            LinearProgressIndicator(
                              value: state.progress!.downloadStatus ==
                                          DownloadStatus.installed ||
                                      state.progress!.downloadStatus ==
                                          DownloadStatus.installing
                                  ? 1
                                  : state.progress!.received /
                                      state.progress!.total,
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // void togglePauseDownload(ctx, BibleDownloadProgess translationInfo) {
  //   BlocProvider.of<BibleDownloadProgressBloc>(context).add(
  //     translationInfo.downloadStatus == DownloadStatus.paused
  //         ? BibleDownloadProgressResume(translationInfo.id)
  //         : BibleDownloadProgressPause(translationInfo.id),
  //   );
  // }
}

class AllBiblesTile extends StatefulWidget {
  final int index;
  final EBible bible;

  const AllBiblesTile({
    super.key,
    required this.bible,
    required this.index,
  });

  @override
  State<AllBiblesTile> createState() => _AllBiblesTileState();
}

class _AllBiblesTileState extends State<AllBiblesTile> {
  bool downloading = false;
  //bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return downloading
        ? DownloadingOverviewTile(bible: widget.bible)
        : FutureBuilder(
            future: Future.value(
                false), //widget.translationInfo.checkIfAlreadyInstalled(),
            builder: (_, snapshot) {
              //bool isAlreadyInstalled = snapshot.hasData && snapshot.data!;

              return HoverableContainer(
                height: 40,
                // onEnter: () => setState(() {
                //   _visible = true;
                // }),
                // onExit: () => setState(() {
                //   _visible = false;
                // }),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                /*
          initialColor: isAlreadyInstalled ||
                  widget.translationInfo.downloadStatus ==
                      DownloadStatus.inProgress
              ? Colors.grey.shade100
              : null,
          */
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
                        widget.bible.bibleName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.bible.bibleName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.bible.langEngName ?? 'Unknown',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () => setState(() {
                          downloading = true;
                        }),
                        //dispatch(context, widget.translationInfo.abbreviation),
                        child: Text(
                          'Download',
                          maxLines: 1,
                        ),
                      ),
                    ),
                    /*
              Expanded(
                flex: 2,
                child: Visibility.maintain(
                  visible: _visible ||
                      isAlreadyInstalled ||
                      widget.translationInfo.downloadStatus ==
                          DownloadStatus.inProgress,
                  child: TextButton(
                    onPressed: isAlreadyInstalled ||
                            widget.translationInfo.downloadStatus ==
                                DownloadStatus.inProgress
                        ? null
                        : () => dispatch(context, widget.translationInfo.id),
                    child: Text(
                      isAlreadyInstalled
                          ? 'Installed'
                          : widget.translationInfo.downloadStatus ==
                                  DownloadStatus.inProgress
                              ? 'Downloading...'
                              : 'Download',
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
          */
                  ],
                ),
              );
            },
          );
  }

  void dispatch(context, String id) {
    BlocProvider.of<BibleDownloadProgressBloc>(context).add(
      BibleDownloadProgressPressed(widget.bible),
    );
  }
}

class InstalledTranslationsOverviewTile extends StatelessWidget {
  final EBible translationInfo;

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
                translationInfo.bibleName.split("\\").last,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () =>
                  dispatch(context, translationInfo.bibleName.split("\\").last),
              child: const Text('Uninstall'),
            ),
          ],
        ),
      ),
    );
  }

  void dispatch(context, String id) {
    BlocProvider.of<InstalledBiblesBloc>(context).add(
      InstalledBiblesUninstall(id),
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
