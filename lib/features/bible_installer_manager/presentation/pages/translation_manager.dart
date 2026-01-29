import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/bible_meta.dart';
import 'package:the_smyrna_bible_v2/features/bible_importer/presentation/widget/importer.dart';
import 'package:the_smyrna_bible_v2/injection_container.dart';

import '../bloc/download_manager/bloc/download_manager_bloc.dart';
import '../bloc/installed_bibles/installed_bibles_bloc.dart';
import '../bloc/remote_catalog/remote_catalog_bloc.dart';
import '../widgets/installed_bibles_section.dart';
import '../widgets/remote_catalog_section.dart';

class BibleManagerWidget extends StatelessWidget {
  const BibleManagerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<InstalledBiblesBloc>()..add(InstalledBiblesLoad()),
        ),
        BlocProvider(
          create: (_) => sl<RemoteCatalogBloc>()
            ..add(RemoteCatalogSubscriptionRequested()),
        ),
        BlocProvider(
          create: (_) => sl<DownloadManagerBloc>(),
        ),
      ],
      child: _BibleManager(),
    );
  }
}

class _BibleManager extends StatefulWidget {
  const _BibleManager();

  @override
  State<_BibleManager> createState() => _BibleManagerState();
}

class _BibleManagerState extends State<_BibleManager> {
  int _index = 0;
  BibleMeta? bibleMeta;
  late final List<Widget> _pages;

  @override
  void initState() {
    _pages = [
      const RemoteCatalogSection(),
      const InstalledBiblesSection(),
      const ImporterWidget(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(42, 8, 42, 42),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 40,
            child: Row(
              children: [
                TextButton(
                  onPressed: () => setState(() => _index = 0),
                  style: ButtonStyle(),
                  child: Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.install_desktop_rounded),
                      Text('Download list'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _index = 1),
                  child: Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.download_done_rounded),
                      Text('Installed list'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _index = 2),
                  child: Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.file_download_outlined),
                      Text('Import'),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: IndexedStack(
              index: _index,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
