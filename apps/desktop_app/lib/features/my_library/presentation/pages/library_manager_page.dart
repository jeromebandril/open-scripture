import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../shared/enums/bible_repository_type.dart';
import '../../../../shared/widgets/ui/b_container_tab_bar.dart';
import '../cubit/my_library_cubit.dart';
import '../widgets/library_view.dart';

class LibrariesPage extends StatefulWidget {
  const LibrariesPage({super.key});

  @override
  State<LibrariesPage> createState() => _LibrariesPageState();
}

class _LibrariesPageState extends State<LibrariesPage> {
  static const _repoTypes = BibleRepositoryType.platformEnabled;

  final _pageConfigs =
      _repoTypes.map((r) => (instanceName: r.name, title: r.label)).toList();

  late final List<Widget> _pages = _pageConfigs
      .map((c) => BlocProvider.value(
            value: di.sl.get<MyLibraryCubit>(instanceName: c.instanceName),
            child: LibraryManagerPage(title: c.title),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: BContainerTabBar(
        tabs: _repoTypes.map((r) => r.label).toList(),
        views: _pages,
      ),
    );
  }
}
