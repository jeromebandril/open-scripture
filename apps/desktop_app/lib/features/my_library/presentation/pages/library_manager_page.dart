import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/get_it_by_type.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../shared/enums/bible_repository_type.dart';
import '../../../../shared/widgets/async_singleton_builder.dart';
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

  final _pageConfigs = _repoTypes;

  late final List<Widget> _pages = _pageConfigs
      .map((repoType) => AsyncSingletonBuilder<MyLibraryCubit>(
            resolver: () => di.sl.resolve<MyLibraryCubit>(repoType),
            builder: (context, cubit) {
              return BlocProvider.value(
                value: cubit,
                child: LibraryManagerPage(
                  title: repoType.label,
                  subtitle: repoType.description,
                  supportUninstallation:
                      repoType != BibleRepositoryType.cloudAPI,
                ),
              );
            },
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
