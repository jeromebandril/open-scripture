import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/core/widgets/hoverable_container.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/data/models/translation_info_model.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/entities/translation_info.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/presentation/bloc/single_translation_download/single_translation_download_bloc.dart';
import 'package:the_smyrna_bible_v2/injection_container.dart';

import '../bloc/all_translations_overview/all_translations_bloc.dart';
import '../bloc/installed_translations_overview/installed_translations_bloc.dart';

// TODO:
// - right now the whole lists are updated on changes
// - DownloadOverview is not scrolling
//
//

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
            Expanded(
              child: Column(
                children: [
                  Expanded(child: DownloadingTranslationsOverview()),
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

class AllTranslationsOverview extends StatelessWidget {
  const AllTranslationsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
      ),
      child: Column(
        children: [
          const SectionHeader('All TRANSLATIONS AVAILABLE'),
          Expanded(
            child: BlocBuilder<AllTranslationsBloc, AllTranslationsState>(
              builder: (context, state) {
                print("building");
                if (state.translationInfos.isEmpty) {
                  if (state.status == AllTranslationsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == AllTranslationsStatus.error) {
                    return Center(child: Text(state.errorMessage ?? 'Error'));
                  }
                }

                return ListView.builder(
                  itemCount: state.translationInfos.length,
                  itemBuilder: (_, index) {
                    return AllTranslationsTile(
                      translationInfo:
                          state.translationInfos[index] as TranslationInfoModel,
                      index: index,
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
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
      ),
      child: Column(
        children: [
          const SectionHeader('DOWNLOAD QUEUE'),
          Expanded(
            child: BlocBuilder<AllTranslationsBloc, AllTranslationsState>(
              builder: (context, state) {
                if (state.status == AllTranslationsStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == AllTranslationsStatus.error) {
                  return const SizedBox();
                } else {
                  final list = state.getDownloadingList();
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      return DownloadingOverviewTile(
                        translationInfo: list[index] as TranslationInfoModel,
                      );
                    },
                  );
                }
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
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
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
                          translationInfo: state.installedTranslations[index]
                              as TranslationInfoModel,
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

/*
const Map<DownloadStatus, String> downloadStatusString = {
  DownloadStatus.downloading: 'Downloading...'
};
*/

// SPECIFIC OVERVIEW TILES TYPES

class DownloadingOverviewTile extends StatefulWidget {
  final TranslationInfoModel translationInfo;
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
          const VerticalDivider(),
          SizedBox(
            width: 150,
            child: Text(
              widget.translationInfo.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const VerticalDivider(),
          SizedBox(
            width: 150,
            child: Text(
              widget.translationInfo.language,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _hovered
                ? TextButton(
                    onPressed: () {},
                    child: const Text('cancel'),
                  )
                : Column(
                    children: [
                      Text(
                        widget.translationInfo.downloadStatus.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const LinearProgressIndicator(
                        value: 0.9,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class AllTranslationsTile extends StatefulWidget {
  final int index;
  final TranslationInfoModel translationInfo;

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
      future: widget.translationInfo.checkIfAlreadyInstalled(),
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
    //BlocProvider.of<AllTranslationsBloc>(context).add();
    BlocProvider.of<SingleTranslationDownloadBloc>(context).add(
      SingleTranslationDownloadPressed(id),
    );
  }
}

class InstalledTranslationsOverviewTile extends StatelessWidget {
  final TranslationInfoModel translationInfo;

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
