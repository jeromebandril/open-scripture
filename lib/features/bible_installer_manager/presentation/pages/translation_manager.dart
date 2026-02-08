import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/shared/domain/entities/bible_meta.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_subpage_navigator.dart';
import 'package:open_scripture/injection_container.dart';

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
    super.initState();
    _pages = [
      const RemoteCatalogSection(),
      const InstalledBiblesSection(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingSubpageNavigator(
            selectedId: _index,
            data: [
              SettingSubpageNavigatorData(
                id: 0,
                onSelect: (id) => setState(() => _index = id),
                icon: Icon(Icons.install_desktop_rounded),
                title: 'Download List',
              ),
              SettingSubpageNavigatorData(
                id: 1,
                onSelect: (id) => setState(() => _index = id),
                icon: Icon(Icons.download_done_rounded),
                title: 'Installed List',
              ),
            ],
          ),
          Expanded(
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
