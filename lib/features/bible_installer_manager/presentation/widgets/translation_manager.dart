import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:the_smyrna_bible_v2/injection_container.dart';

import '../bloc/download_manager/bloc/download_manager_bloc.dart';
import '../bloc/installed_bibles/installed_bibles_bloc.dart';
import '../bloc/remote_catalog/remote_catalog_bloc.dart';
import 'installed_bibles/installed_bibles_section.dart';
import 'remote_catalog/remote_catalog_section.dart';

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

class _BibleManager extends StatelessWidget {
  const _BibleManager();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(42, 8, 42, 42),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: RemoteCatalogSection(),
          ),
          Gap(8),
          Expanded(
            flex: 8,
            child: InstalledBiblesSection(),
          ),
        ],
      ),
    );
  }
}
